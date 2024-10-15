Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA6B31C57B1;
	Tue, 15 Oct 2024 12:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993822; cv=none; b=Tw+/Kw6jHwKzpxSM8FPWhKarzyHdg293lRtwnM2LhDKbZrxQ6XXvuqwmRByikVI052DSdPuoRp5bpQoqtZmok9bG/n30Vr+E4I0qYDU/Rwds5DfkN4V+DC+B2m6E7QKa3bu8SAB0MjYRMxAyxNf1FxCZ/dN05ZBU86dxBB+fCyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993822; c=relaxed/simple;
	bh=AnxZlRQjUlOq55lvfajKsdeWNje2M0yiIQFkCrsUMFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bUHSH3yXjUcc2rzXnxXeDU05AUa57qdrqzJTNIx/k2lx+Hbb9/9/zPs6plMk7DTHMNeoXfJF2fueNAYw9L5LsGeK2PYl/B7AGSafUTvLU4CXkiNcFbo9M419SG+NDOEHVoloyAHBW2d0ZbEq61hDbgOf07rj2y5yOQKs08mR3jQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bv/4M/gt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bv/4M/gt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28063C4CEC6;
	Tue, 15 Oct 2024 12:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993822;
	bh=AnxZlRQjUlOq55lvfajKsdeWNje2M0yiIQFkCrsUMFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bv/4M/gtbYd6L/3zBqAkhtTNcU38BrjQPU10YFJ8ukRzjAL+J4paNBeEqxqE6gASC
	 eoQ2yNfnTrHom6rKNz7wvMrzkS4S864Vf8ZPyB2PnaizbeZ4tHyKIgyIOp5+CFsc7P
	 4j+iH7x8YVAAyBtiXEa223zp8TTp88KORF+DDj+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.15 527/691] media: uapi/linux/cec.h: cec_msg_set_reply_to: zero flags
Date: Tue, 15 Oct 2024 13:27:55 +0200
Message-ID: <20241015112501.257535041@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

commit 599f6899051cb70c4e0aa9fd591b9ee220cb6f14 upstream.

The cec_msg_set_reply_to() helper function never zeroed the
struct cec_msg flags field, this can cause unexpected behavior
if flags was uninitialized to begin with.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Fixes: 0dbacebede1e ("[media] cec: move the CEC framework out of staging and to media")
Cc: <stable@vger.kernel.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/cec.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/include/uapi/linux/cec.h
+++ b/include/uapi/linux/cec.h
@@ -132,6 +132,8 @@ static inline void cec_msg_init(struct c
  * Set the msg destination to the orig initiator and the msg initiator to the
  * orig destination. Note that msg and orig may be the same pointer, in which
  * case the change is done in place.
+ *
+ * It also zeroes the reply, timeout and flags fields.
  */
 static inline void cec_msg_set_reply_to(struct cec_msg *msg,
 					struct cec_msg *orig)
@@ -139,7 +141,9 @@ static inline void cec_msg_set_reply_to(
 	/* The destination becomes the initiator and vice versa */
 	msg->msg[0] = (cec_msg_destination(orig) << 4) |
 		      cec_msg_initiator(orig);
-	msg->reply = msg->timeout = 0;
+	msg->reply = 0;
+	msg->timeout = 0;
+	msg->flags = 0;
 }
 
 /* cec_msg flags field */


