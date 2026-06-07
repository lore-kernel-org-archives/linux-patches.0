Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E4933195FD;
	Sun,  7 Jun 2026 10:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828954; cv=none; b=edUBoQTQHq2bL2lHazu8SLskI02c60ZeUvCoOUq4eV5Bv3Vx6F6ZVXDRKvx1y97tluPTf5XlXRG4qsuRQDaPas07fLkJrkwIUjURw35pkdBfchoSQV/o6BsUs8z6/X9bGyrXZFycHG7cs1TynjMeOEkRN2uxhRQcRasj8UVfcWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828954; c=relaxed/simple;
	bh=Mox1FMoI2Z69fJ/p7/GDxJe/5ES3tnWwnXWH9JXv9ww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BBWiGk4qAhoCAGQdnKPPXYXl281rBcHKLl9gHbIn8VOoTRyXfh8Rs9FEl2abmZFdJ1WUI9CbQbelJi4aJevsoNAEN4V8Eox5RsZPZIM7dMbNIQZTmQ764iAc5fCsiX/ucClIPRlkI2BCyiTOac23Ug1RgiWLC47IMxXes1a5BQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CVitpP2T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CVitpP2T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D026B1F00893;
	Sun,  7 Jun 2026 10:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828953;
	bh=ZS+MPx+X2afJUafj9mGwqrpZiJeI5i6m2w8K5gMNitQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CVitpP2TZDkxn+ZdkaC9J+3mOVR4pzI6LePdCNPL9Nt5LS8eMoS3eCjukbVw6qk7p
	 PLYa7x8R0qPWsT+LOsmRS/hrMn+Iyem3UKP2FpDRP3Ama5BcgFfXJv2QP0qaVE4A4Z
	 Bwvl+l2ZgINsgQg8Ld7S3VB+juOewwVQGQsxH6lI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 182/307] Input: elan_i2c - validate firmware size before use
Date: Sun,  7 Jun 2026 11:59:39 +0200
Message-ID: <20260607095734.400828076@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 76b0d0baa9ae9c60e726bbe1b6ff0bec2c993634 upstream.

Ensure that the firmware file is large enough to contain the expected
number of pages and the signature (which resides at the end of the
firmware blob) before accessing them to prevent potential out-of-bounds
reads.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/ae2dOgiFvXRm4BHo@google.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/mouse/elan_i2c_core.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/input/mouse/elan_i2c_core.c
+++ b/drivers/input/mouse/elan_i2c_core.c
@@ -645,6 +645,11 @@ static ssize_t elan_sysfs_update_fw(stru
 		return error;
 	}
 
+	if (fw->size < data->fw_signature_address + sizeof(signature)) {
+		dev_err(dev, "firmware file too small\n");
+		return -EBADF;
+	}
+
 	/* Firmware file must match signature data */
 	fw_signature = &fw->data[data->fw_signature_address];
 	if (memcmp(fw_signature, signature, sizeof(signature)) != 0) {


