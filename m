Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60CB139FEE;
	Fri, 24 Nov 2023 18:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e6a7s3vv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E04D5C433C8;
	Fri, 24 Nov 2023 18:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700848938;
	bh=y9/5QWP4uyW8/T9UVeIpEs9qdg12mS/C8fH7nvxljmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e6a7s3vv4mIgQ+iuTMuUwdYbxVlD6rrROgM3+J2i05svOBsPKcXpRPV9WxCEfKUlf
	 ODZtYJYkvTHqU84muzWKNqFU+Rh2e31NKCpB2QGoOUE6nqxT/MZKJg4SjHJ252wL2K
	 Dn89brflXOn9LAQvj6Ehp7pURify3MKMW/w7QpUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jose Javier Rodriguez Barbarin <JoseJavier.Rodriguez@duagon.com>,
	Jorge Sanjuan Garcia <jorge.sanjuangarcia@duagon.com>
Subject: [PATCH 4.14 41/57] mcb: fix error handling for different scenarios when parsing
Date: Fri, 24 Nov 2023 17:51:05 +0000
Message-ID: <20231124171931.827079880@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171930.281665051@linuxfoundation.org>
References: <20231124171930.281665051@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sanjuán García, Jorge <Jorge.SanjuanGarcia@duagon.com>

commit 63ba2d07b4be72b94216d20561f43e1150b25d98 upstream.

chameleon_parse_gdd() may fail for different reasons and end up
in the err tag. Make sure we at least always free the mcb_device
allocated with mcb_alloc_dev().

If mcb_device_register() fails, make sure to give up the reference
in the same place the device was added.

Fixes: 728ac3389296 ("mcb: mcb-parse: fix error handing in chameleon_parse_gdd()")
Cc: stable <stable@kernel.org>
Reviewed-by: Jose Javier Rodriguez Barbarin <JoseJavier.Rodriguez@duagon.com>
Signed-off-by: Jorge Sanjuan Garcia <jorge.sanjuangarcia@duagon.com>
Link: https://lore.kernel.org/r/20231019141434.57971-2-jorge.sanjuangarcia@duagon.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mcb/mcb-core.c  |    1 +
 drivers/mcb/mcb-parse.c |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/mcb/mcb-core.c
+++ b/drivers/mcb/mcb-core.c
@@ -251,6 +251,7 @@ int mcb_device_register(struct mcb_bus *
 	return 0;
 
 out:
+	put_device(&dev->dev);
 
 	return ret;
 }
--- a/drivers/mcb/mcb-parse.c
+++ b/drivers/mcb/mcb-parse.c
@@ -105,7 +105,7 @@ static int chameleon_parse_gdd(struct mc
 	return 0;
 
 err:
-	put_device(&mdev->dev);
+	mcb_free_dev(mdev);
 
 	return ret;
 }


