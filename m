Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49755268685;
	Tue,  8 Apr 2025 10:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744109707; cv=none; b=CJVYZ08kM15lxg6Z1mY6MvbAEn7QANI0TphxgLZANmnjdvb4chEbaluiXp72jGUTs33SOUin9g8TX+bD+CQVLRJjf9VMG6oBs/3JCyETZeG6r59Bm9Rv/u+PFT9xr/I7PW9edmvGJlJZ30bg2Q2Xyrfp6+EMMlpybBIZfhRTJgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744109707; c=relaxed/simple;
	bh=grofnWkjnHZGM2xtToPMWQ4OqicTxYTOv8T95E3yuHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nkz7sisb/fTHUHEs0PZAG2LlFBdfAyNAoUqFqVlEZR8asNBcMOybnIlnomyGaKHRf7jSNCeWzlM4C0hKrriqEPEz8L+8ypb9i/M6Ye6I+Ouz3afrynFAwvrOrw+Rp1XFAYmxUx9YWBfM8UiH/oS0aaRgIpGaelUXkfJTSEE9fdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1NHwWuuZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1NHwWuuZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD6F5C4CEE5;
	Tue,  8 Apr 2025 10:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744109707;
	bh=grofnWkjnHZGM2xtToPMWQ4OqicTxYTOv8T95E3yuHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1NHwWuuZLY5FaTGLyERk7TZZUCx59gPhXLZeXii11O4cxifeXm0bJ/Ij10t7ViibQ
	 /97Pil/WzS/yX5oVZ0qXhVYQr1uRg47dh6ruIyG3lNKEoR+GmwXmBrVFotS98Yl4UT
	 Ki1s5RFZp9IRXdhVwOoCQ6jS0qEao8cUZ95mQSBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 023/227] powercap: call put_device() on an error path in powercap_register_control_type()
Date: Tue,  8 Apr 2025 12:46:41 +0200
Message-ID: <20250408104821.090094647@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

[ Upstream commit 93c66fbc280747ea700bd6199633d661e3c819b3 ]

powercap_register_control_type() calls device_register(), but does not
release the refcount of the device when it fails.

Call put_device() before returning an error to balance the refcount.

Since the kfree(control_type) will be done by powercap_release(), remove
the lines in powercap_register_control_type() before returning the error.

This bug was found by an experimental verifier that I am developing.

Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Link: https://patch.msgid.link/20250110010554.1583411-1-joe@pf.is.s.u-tokyo.ac.jp
[ rjw: Changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/powercap/powercap_sys.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/powercap/powercap_sys.c b/drivers/powercap/powercap_sys.c
index 7a3109a538813..fe5d05da7ce7a 100644
--- a/drivers/powercap/powercap_sys.c
+++ b/drivers/powercap/powercap_sys.c
@@ -627,8 +627,7 @@ struct powercap_control_type *powercap_register_control_type(
 	dev_set_name(&control_type->dev, "%s", name);
 	result = device_register(&control_type->dev);
 	if (result) {
-		if (control_type->allocated)
-			kfree(control_type);
+		put_device(&control_type->dev);
 		return ERR_PTR(result);
 	}
 	idr_init(&control_type->idr);
-- 
2.39.5



