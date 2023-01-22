Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B09E97E
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:06:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 393C1C433D2;
	Sun, 22 Jan 2023 15:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400011;
	bh=bUmI9+Y6UTIoszobnSkRjDlTI95vA/LfTmBQlFUeabs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HeSUM9Ixy5YaF6l2yhur96B/h4mIkPhPW3f8i1AqlBpdneOkJ4F82LVw2OwxewLRt
	 tH0/EHff0jY3KQhQ5ejmJJB+vaEdGLlaZ3OSepQI467JYuJX6d2lBUk3vQgHZ9JDqK
	 ybGKjJfjUDWFYJG3N9Awq8sSPAp5O8GZfmuhZzqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jordy Zomer <jordyzomer@google.com>,
	Linus Torvalds <torvalds@linuxfoundation.org>
Subject: [PATCH 4.14 08/25] prlimit: do_prlimit needs to have a speculation check
Date: Sun, 22 Jan 2023 16:04:08 +0100
Message-Id: <20230122150218.150123151@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150217.788215473@linuxfoundation.org>
References: <20230122150217.788215473@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 739790605705ddcf18f21782b9c99ad7d53a8c11 upstream.

do_prlimit() adds the user-controlled resource value to a pointer that
will subsequently be dereferenced.  In order to help prevent this
codepath from being used as a spectre "gadget" a barrier needs to be
added after checking the range.

Reported-by: Jordy Zomer <jordyzomer@google.com>
Tested-by: Jordy Zomer <jordyzomer@google.com>
Suggested-by: Linus Torvalds <torvalds@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sys.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1472,6 +1472,8 @@ int do_prlimit(struct task_struct *tsk,
 
 	if (resource >= RLIM_NLIMITS)
 		return -EINVAL;
+	resource = array_index_nospec(resource, RLIM_NLIMITS);
+
 	if (new_rlim) {
 		if (new_rlim->rlim_cur > new_rlim->rlim_max)
 			return -EINVAL;


