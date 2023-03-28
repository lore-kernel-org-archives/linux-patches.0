Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6C9B8476
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:54:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 684B1C4339B;
	Tue, 28 Mar 2023 14:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015268;
	bh=auzT78B8sTYFbmdAMJSvXW38zALVULSPkuQHYRo5wJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l/FQuIMqHRy4fIwa2BuHBtqy+Ky1tJ+mfhqLS74qgkMlnyZ7oFUoYyl6RRWe2bM8X
	 xAf1nkbOUEuwmG/WSz0yQjJwMuwIqpdOCG15CgPQTvmJN4fqLAa98ZXhaA9OvD5Jts
	 RL6eNDZ13BoUNvgcG2E+uB6g+n48DetSDBvJXMKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rijo Thomas <Rijo-john.Thomas@amd.com>,
	Sumit Garg <sumit.garg@linaro.org>,
	Jens Wiklander <jens.wiklander@linaro.org>
Subject: [PATCH 6.2 227/240] tee: amdtee: fix race condition in amdtee_open_session
Date: Tue, 28 Mar 2023 16:43:10 +0200
Message-Id: <20230328142629.187600434@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rijo Thomas <Rijo-john.Thomas@amd.com>

commit f8502fba45bd30e1a6a354d9d898bc99d1a11e6d upstream.

There is a potential race condition in amdtee_open_session that may
lead to use-after-free. For instance, in amdtee_open_session() after
sess->sess_mask is set, and before setting:

    sess->session_info[i] = session_info;

if amdtee_close_session() closes this same session, then 'sess' data
structure will be released, causing kernel panic when 'sess' is
accessed within amdtee_open_session().

The solution is to set the bit sess->sess_mask as the last step in
amdtee_open_session().

Fixes: 757cc3e9ff1d ("tee: add AMD-TEE driver")
Cc: stable@vger.kernel.org
Signed-off-by: Rijo Thomas <Rijo-john.Thomas@amd.com>
Acked-by: Sumit Garg <sumit.garg@linaro.org>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tee/amdtee/core.c |   29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

--- a/drivers/tee/amdtee/core.c
+++ b/drivers/tee/amdtee/core.c
@@ -267,35 +267,34 @@ int amdtee_open_session(struct tee_conte
 		goto out;
 	}
 
+	/* Open session with loaded TA */
+	handle_open_session(arg, &session_info, param);
+	if (arg->ret != TEEC_SUCCESS) {
+		pr_err("open_session failed %d\n", arg->ret);
+		handle_unload_ta(ta_handle);
+		kref_put(&sess->refcount, destroy_session);
+		goto out;
+	}
+
 	/* Find an empty session index for the given TA */
 	spin_lock(&sess->lock);
 	i = find_first_zero_bit(sess->sess_mask, TEE_NUM_SESSIONS);
-	if (i < TEE_NUM_SESSIONS)
+	if (i < TEE_NUM_SESSIONS) {
+		sess->session_info[i] = session_info;
+		set_session_id(ta_handle, i, &arg->session);
 		set_bit(i, sess->sess_mask);
+	}
 	spin_unlock(&sess->lock);
 
 	if (i >= TEE_NUM_SESSIONS) {
 		pr_err("reached maximum session count %d\n", TEE_NUM_SESSIONS);
+		handle_close_session(ta_handle, session_info);
 		handle_unload_ta(ta_handle);
 		kref_put(&sess->refcount, destroy_session);
 		rc = -ENOMEM;
 		goto out;
 	}
 
-	/* Open session with loaded TA */
-	handle_open_session(arg, &session_info, param);
-	if (arg->ret != TEEC_SUCCESS) {
-		pr_err("open_session failed %d\n", arg->ret);
-		spin_lock(&sess->lock);
-		clear_bit(i, sess->sess_mask);
-		spin_unlock(&sess->lock);
-		handle_unload_ta(ta_handle);
-		kref_put(&sess->refcount, destroy_session);
-		goto out;
-	}
-
-	sess->session_info[i] = session_info;
-	set_session_id(ta_handle, i, &arg->session);
 out:
 	free_pages((u64)ta, get_order(ta_size));
 	return rc;


