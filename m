Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F08B8F58
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 15:06:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA542C4339B;
	Mon, 13 Feb 2023 15:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676300762;
	bh=5MxSNYSDPC4S3znAuFkHEzobPbcX0NWsoJQ3a9jV6AI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QTrv7ejKLPAqqFRPhLwaEec1jv8G3Yk3Mhq4EkhjHVWKEc8jPxrot1inh+kDgj4Kp
	 0xzvS8iD0IIM8/+2U8K7JIdqI1pGdhHKDHtRn54GQ4IMWC+6lMDrNND5mLmCIRAvNK
	 dQH2cKv7mTKZUA4+/11sJU9WOhOLp5ZGXbIsZwak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 5.10 139/139] nvmem: core: fix return value
Date: Mon, 13 Feb 2023 15:51:24 +0100
Message-Id: <20230213144753.376308293@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144745.696901179@linuxfoundation.org>
References: <20230213144745.696901179@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

commit 0c4862b1c1465e473bc961a02765490578bf5c20 upstream.

Dan Carpenter points out that the return code was not set in commit
60c8b4aebd8e ("nvmem: core: fix cleanup after dev_set_name()"), but
this is not the only issue - we also need to zero wp_gpio to prevent
gpiod_put() being called on an error value.

Fixes: 560181d3ace6 ("nvmem: core: fix cleanup after dev_set_name()")
Cc: stable@vger.kernel.org
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20230127104015.23839-10-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -638,6 +638,7 @@ struct nvmem_device *nvmem_register(cons
 						    GPIOD_OUT_HIGH);
 	if (IS_ERR(nvmem->wp_gpio)) {
 		rval = PTR_ERR(nvmem->wp_gpio);
+		nvmem->wp_gpio = NULL;
 		goto err_put_device;
 	}
 


