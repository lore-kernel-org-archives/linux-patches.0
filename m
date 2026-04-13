Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 584AC25DB12;
	Mon, 13 Apr 2026 16:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096826; cv=none; b=YOcWsk7/JtXlH5+2eKAulB5eKioG60jOsmkF77ZYgKO6KeKQPyTL0QvY9IkVXBan9MUPWdAGRyqlcFGm8KRByAMbYZOZwplmptQm8rHPOX6YDdtE9tm8RmHtxsm3J2J8WPnWN/+N47yHZjP+Lgzic4xt1PX4bVfc/iCsd3SLC2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096826; c=relaxed/simple;
	bh=c6VGH40ZvsQMh1P3d0ogdaBu0cQvHt4Dd1T7KkShAAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MR5hUvVPv/DCXwDbPc9xmCQHTudWPdlGt2KV1ToLxNl/9YxgnrKrR9NyNddbojA0wfi52A/GYDYMzVuOY4XHnn30DK4+F/HzVihtHJlXKZFjjaFp2R77xB2QxP92yi+K8DuUah6pU1nGdlbQj3wXyt41V5819Bko7aywMPcfcPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GPVIKoTe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GPVIKoTe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E305DC2BCAF;
	Mon, 13 Apr 2026 16:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096826;
	bh=c6VGH40ZvsQMh1P3d0ogdaBu0cQvHt4Dd1T7KkShAAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GPVIKoTeLDCqWzSPoGE/3wiwi5/P6OgVvvkXoUekQzpPylP17fJz7oiM4DK3p0Ker
	 xpBJNlQ9h2yrZSCQN8q/QU4jnI0Nq7HmUiDcxgPV6MSoy8j/tUuPtow8VomF7Stjiw
	 30lgtOAuyIYf9hTknHzkhqhIduQwEYDJRTJMmcJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emil Tantilov <emil.s.tantilov@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Li Li <boolli@google.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Samuel Salin <Samuel.salin@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 6.12 57/70] idpf: set the payload size before calling the async handler
Date: Mon, 13 Apr 2026 18:00:52 +0200
Message-ID: <20260413155730.313761607@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155728.181580293@linuxfoundation.org>
References: <20260413155728.181580293@linuxfoundation.org>
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

From: Emil Tantilov <emil.s.tantilov@intel.com>

commit 8e2a2420e267a515f6db56a6e9570b5cacd92919 upstream.

Set the payload size before forwarding the reply to the async handler.
Without this, xn->reply_sz will be 0 and idpf_mac_filter_async_handler()
will never get past the size check.

Fixes: 34c21fa894a1 ("idpf: implement virtchnl transaction manager")
Cc: stable@vger.kernel.org
Signed-off-by: Emil Tantilov <emil.s.tantilov@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Li Li <boolli@google.com>
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Tested-by: Samuel Salin <Samuel.salin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/idpf/idpf_virtchnl.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
@@ -641,6 +641,10 @@ idpf_vc_xn_forward_reply(struct idpf_ada
 		err = -ENXIO;
 		goto out_unlock;
 	case IDPF_VC_XN_ASYNC:
+		/* Set reply_sz from the actual payload so that async_handler
+		 * can evaluate the response.
+		 */
+		xn->reply_sz = ctlq_msg->data_len;
 		err = idpf_vc_xn_forward_async(adapter, xn, ctlq_msg);
 		idpf_vc_xn_unlock(xn);
 		return err;


