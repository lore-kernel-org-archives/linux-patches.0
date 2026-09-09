Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 054D2566C5B;
	Wed,  9 Sep 2026 14:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962724; cv=none; b=CFHOH/jfaB2gP6J6OWx5yupzGMIYL5Pn5IMS+mTBT7weIUVarcsv8RQ4o2NDHmFwQIJOxDw2xsOyXSALr3qbLRvmmLSg3X7PkFIn9kXYS7SIpM1M6RjrveF+rXZVis8Zz2TcRBi5hVs5+e36ujfWtC5JbekeQvgq3YXjjM8a2lE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962724; c=relaxed/simple;
	bh=ksF0vM8wVIjPLOpLg4gYZacppoaLykxLl1mdDmerB7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IQsoZ5QJnQSY7NsIpVPsgzH/5CiW9gmezEg/BN6G1AZFb8Kn7EogxRLU9idqKhQ+GLFeGYvOP43oO50fPEH6UeAO1emAWqntRyYW4r0Uh7/CrOhs3rK0jydF0g4ZR/iAug1aSs41TcwQlRAehDVcDrEpKP3ZkjAgZp3A07pM+Rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wqw4iw4T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wqw4iw4T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F0881F00A3A;
	Wed,  9 Sep 2026 14:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962722;
	bh=XV7ir84R3sXDoTxgh0+s+Iussvk8Qh7+QYxd6EZd6eM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wqw4iw4T3CamgqN/nS/V3gTozu+Z6KkfyOvbm5Ej5Lp8TAOd9qrEdBjW9ODW921eB
	 nahffHuPZAnlZwxtiMU2KYWtS6enlTak3BiM5Q7g6S4u+DNVLmpwgzCo0pZYxfeat0
	 via5slp/ZzrNcAlgm1bgcWCEvW2+34DKOuFO8rkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sean Young <sean@mess.org>
Subject: [PATCH 7.2 351/556] media: cec: extron-da-hd-4k-plus: add sanity check
Date: Wed,  9 Sep 2026 15:40:31 +0200
Message-ID: <20260909134243.006013863@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -657,7 +657,8 @@ static void extron_process_received(stru
 	if (!port || port->disconnected)
 		return;
 
-	if (len < 5 || (len - 2) % 3 || data[len - 2] != '*')
+	if (len < 5 || ((len - 2) / 3 > sizeof(msg.msg)) ||
+	    (len - 2) % 3 || data[len - 2] != '*')
 		goto malformed;
 
 	while (*data != '*') {


