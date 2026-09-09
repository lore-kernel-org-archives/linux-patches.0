Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E535559CB6;
	Wed,  9 Sep 2026 14:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964143; cv=none; b=I0QE2S4AwqkxFcKlsiXGlZuaQGU9ul8HVp9iooheHJdC1Z4tcyG4P1VPHRpxpHWyP/fLRpvk2iebH7DVWLf85yvt3HB9QZ2DhVIZjajCnU5uaRKTigem4ultopNgVkQ9kPDjOv1YakTxy/gLMY6SgS3YG+WUtHyNLsWTo6re8pE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964143; c=relaxed/simple;
	bh=s+GsJvR236TWuCMheQnNez+m1lyhX7VgxXV3XWgFoLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SUaslR/liENqvDG5Txy/Evxgkg10t7yWJLzeKePqZjsGyBa0SgzJjAHjK9AoDB1eswIML6txJQz7NRB+IhglFsjb37Fqt4+0emNWYE7C71yK38muI2nB67E7qQ6JXLnwNHeGIhv58kDtVhlAyc+pL6PLvsLsBEsfvjuYGumBfyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lovGKhNj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lovGKhNj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 652D01F00A3A;
	Wed,  9 Sep 2026 14:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964141;
	bh=GLM/pVTB43V+B/dIE8be/hS/J7dqPPSSUahJblMSvhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lovGKhNjTHOLV/tXaMRKP0PMf+duakLZE1z8dbE7kMavbiNi02xDDVhPAONjgNx3u
	 m767+LlfCoSQge+Phd5ieEfFPk3K5P7uaXIXY7qWyfb21U8ltkzUhNyYqiF52nusi/
	 lipB71/uvrtt76VJXQkRNNX0zyCa05mu8++B83Lk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sean Young <sean@mess.org>
Subject: [PATCH 6.18 278/583] media: cec: extron-da-hd-4k-plus: add sanity check
Date: Wed,  9 Sep 2026 15:39:23 +0200
Message-ID: <20260909134247.694459930@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hverkuil+cisco@kernel.org>

commit abac9820b26b5cfcb01eb79efe2abdd0ac7e07c3 upstream.

Add check to prevent overflowing msg.msg[] in case the incoming data
is malformed.

Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Reviewed-by: Sean Young <sean@mess.org>
Fixes: 056f2821b631 ("media: cec: extron-da-hd-4k-plus: add the Extron DA HD 4K Plus CEC driver")
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/cec/usb/extron-da-hd-4k-plus/extron-da-hd-4k-plus.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/media/cec/usb/extron-da-hd-4k-plus/extron-da-hd-4k-plus.c
+++ b/drivers/media/cec/usb/extron-da-hd-4k-plus/extron-da-hd-4k-plus.c
@@ -656,7 +656,8 @@ static void extron_process_received(stru
 	if (!port || port->disconnected)
 		return;
 
-	if (len < 5 || (len - 2) % 3 || data[len - 2] != '*')
+	if (len < 5 || ((len - 2) / 3 > sizeof(msg.msg)) ||
+	    (len - 2) % 3 || data[len - 2] != '*')
 		goto malformed;
 
 	while (*data != '*') {


