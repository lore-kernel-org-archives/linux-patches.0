Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8072632B11D;
	Sat, 30 May 2026 17:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160759; cv=none; b=MX61NQPPLChpo+04/JMKLmmMul0zNY4P9vkuyBUTEK8GqLD37BIlt6snfNjjkP4AI8tUyEeo7X0b5+eaDtumO61BoHhmYeUbiDOG5G8DKW2g1w+xv3dwSDR8uOvy5/rNSLFsj1VmXkZ0YLRApOMvPdoEtb6cFflzlf+EpFZPHrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160759; c=relaxed/simple;
	bh=vAFCwv2LnHASzWaZ2F5q6L+20YbBGz2uOQFsIM0Gvsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b624ycmqTfdpJwT7rY/eSgi4JBT83K1c1/bUFZyutW3dgwmTGSCXbD6bMhGyn7R05sAORivn9niowDBpAAOsK/YxlNfK+BD2KV2t9HcKXTUECI4CeCBHoGnRlJJq/8xx8ZOKfh+0eHRmH3pC9Qjt8lM55rl+msI0RoGrKYygywo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NEoM2SDf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NEoM2SDf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A937F1F00893;
	Sat, 30 May 2026 17:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160758;
	bh=PHBCsMo3v1WVIRvuVGk99hJTnBMtWL/jBgitcrHjLHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NEoM2SDfVZ9T3WfW9HLORJKbk48SOaKMgNeU1hcQUQ6CK+U8s/HJlosnhI5QEKg2y
	 ck1YWsH+aXf5G9eZLj8vClCgJ5VFbNPghwYqWTPThX2YkvD71owhYQUQUl7O/u2ekJ
	 kgoUeCZo0gAQBWPPXzt6fE0nTjsfdgcZrdLksCSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Norbert Szetei <norbert@doyensec.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Luigi Leonardi <leonardi@redhat.com>
Subject: [PATCH 6.1 426/969] vsock: fix buffer size clamping order
Date: Sat, 30 May 2026 17:59:10 +0200
Message-ID: <20260530160312.024226059@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Norbert Szetei <norbert@doyensec.com>

commit d114bfdc9b76bf93b881e195b7ec957c14227bab upstream.

In vsock_update_buffer_size(), the buffer size was being clamped to the
maximum first, and then to the minimum. If a user sets a minimum buffer
size larger than the maximum, the minimum check overrides the maximum
check, inverting the constraint.

This breaks the intended socket memory boundaries by allowing the
vsk->buffer_size to grow beyond the configured vsk->buffer_max_size.

Fix this by checking the minimum first, and then the maximum. This
ensures the buffer size never exceeds the buffer_max_size.

Fixes: b9f2b0ffde0c ("vsock: handle buffer_size sockopts in the core")
Suggested-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Norbert Szetei <norbert@doyensec.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://patch.msgid.link/180118C5-8BCF-4A63-A305-4EE53A34AB9C@doyensec.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Cc: Luigi Leonardi <leonardi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/af_vsock.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1680,12 +1680,12 @@ static void vsock_update_buffer_size(str
 				     const struct vsock_transport *transport,
 				     u64 val)
 {
-	if (val > vsk->buffer_max_size)
-		val = vsk->buffer_max_size;
-
 	if (val < vsk->buffer_min_size)
 		val = vsk->buffer_min_size;
 
+	if (val > vsk->buffer_max_size)
+		val = vsk->buffer_max_size;
+
 	if (val != vsk->buffer_size &&
 	    transport && transport->notify_buffer_size)
 		transport->notify_buffer_size(vsk, &val);


