Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C054F847E
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 13:54:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9FB0C433D2;
	Fri, 10 Mar 2023 13:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678456458;
	bh=s8HttMRlfxiQVjgYNpcGtmLGKklX1y1jNFUtoylxP2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cQNj79g/Cs0TBUpknDRjJgFKaOw72bZgFLFmkveia57EUIyF4H3Pa4DoWT9H1n8w2
	 Fa0Tb07A+hjjeqz5tHNTvXgmB3LMfzIej3xpPxSZsNCrAfxejo5yT8z6xOC8TlVvkw
	 ollHHjaxs+A9/vXEI+D88DUYrr6Hp9Ej4N8v6DX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	kernel test robot <lkp@intel.com>,
	Jianglei Nie <niejianglei2021@163.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 002/211] auxdisplay: hd44780: Fix potential memory leak in hd44780_remove()
Date: Fri, 10 Mar 2023 14:36:22 +0100
Message-Id: <20230310133718.767222555@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jianglei Nie <niejianglei2021@163.com>

[ Upstream commit ddf75a86aba2cfb7ec4497e8692b60c8c8fe0ee7 ]

hd44780_probe() allocates a memory chunk for hd with kzalloc() and
makes "lcd->drvdata->hd44780" point to it. When we call hd44780_remove(),
we should release all relevant memory and resource. But "lcd->drvdata
->hd44780" is not released, which will lead to a memory leak.

We should release the "lcd->drvdata->hd44780" in hd44780_remove() to fix
the memory leak bug.

Fixes: 718e05ed92ec ("auxdisplay: Introduce hd44780_common.[ch]")
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/auxdisplay/hd44780.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/auxdisplay/hd44780.c b/drivers/auxdisplay/hd44780.c
index 8b2a0eb3f32a4..d56a5d508ccd7 100644
--- a/drivers/auxdisplay/hd44780.c
+++ b/drivers/auxdisplay/hd44780.c
@@ -322,8 +322,10 @@ static int hd44780_probe(struct platform_device *pdev)
 static int hd44780_remove(struct platform_device *pdev)
 {
 	struct charlcd *lcd = platform_get_drvdata(pdev);
+	struct hd44780_common *hdc = lcd->drvdata;
 
 	charlcd_unregister(lcd);
+	kfree(hdc->hd44780);
 	kfree(lcd->drvdata);
 
 	kfree(lcd);
-- 
2.39.2



