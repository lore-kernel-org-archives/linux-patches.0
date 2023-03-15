Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0FE4431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:16:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76F49C433D2;
	Wed, 15 Mar 2023 12:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678882566;
	bh=9jBS7MIpL6+m9brClPSSCvHFrvezPWT/iN0VihTnzSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QcF3HaD88PcoHDqKnMluRs1tLzUUmC3TNcL+vyHcNX/jawV0oqSbl+gFGQdXjgKhq
	 EahQNpNMqiarWqy7/EuJCbtHarfN9XDyPne6bkNHAS/6kxtm8Qhrfgoal1iWbaYPqs
	 N+9wjYv9k5tPXh0UrjGDvZR7LxU80FeYwVXLNPx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Nobuhiro Iwamatsu (CIP)" <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 4.19 27/39] Revert "spi: mt7621: Fix an error message in mt7621_spi_probe()"
Date: Wed, 15 Mar 2023 13:12:41 +0100
Message-Id: <20230315115722.239035576@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115721.234756306@linuxfoundation.org>
References: <20230315115721.234756306@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>

This reverts commit 269f650a0b26067092873308117e0bf0c6ec8289 which is
commit 2b2bf6b7faa9010fae10dc7de76627a3fdb525b3 upstream.

dev_err_probe() does not suppot in 4.19.y. So this driver will fail to
build.

```
  CC      drivers/staging/mt7621-spi/spi-mt7621.o
drivers/staging/mt7621-spi/spi-mt7621.c: In function 'mt7621_spi_probe':
drivers/staging/mt7621-spi/spi-mt7621.c:446:24: error: implicit declaration of function 'dev_err_probe'; did you mean 'device_reprobe'? [-Werror=implicit-function-declaration]
  446 |                 return dev_err_probe(&pdev->dev, PTR_ERR(clk),
      |                        ^~~~~~~~~~~~~
      |                        device_reprobe
```

Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/mt7621-spi/spi-mt7621.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/staging/mt7621-spi/spi-mt7621.c
+++ b/drivers/staging/mt7621-spi/spi-mt7621.c
@@ -442,9 +442,11 @@ static int mt7621_spi_probe(struct platf
 		return PTR_ERR(base);
 
 	clk = devm_clk_get(&pdev->dev, NULL);
-	if (IS_ERR(clk))
-		return dev_err_probe(&pdev->dev, PTR_ERR(clk),
-				     "unable to get SYS clock\n");
+	if (IS_ERR(clk)) {
+		dev_err(&pdev->dev, "unable to get SYS clock, err=%d\n",
+			status);
+		return PTR_ERR(clk);
+	}
 
 	status = clk_prepare_enable(clk);
 	if (status)


