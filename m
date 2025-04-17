Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3749B25A654;
	Thu, 17 Apr 2025 18:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914879; cv=none; b=hgTEWZvUJoF+SkYIKovr8Z3R/3YBCYwAUpBYK1saCYL6tQHP+knOKxbgc+uw/OyKIei99GsyhQGoYtalS0wMRedWLsJmhhv9cEA48e4ustSfc8QzP77D0DH0koBvOlfMpwSELMS8zcDROsATy1Bhpci2pNWfiSU0YHC8U+b4iu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914879; c=relaxed/simple;
	bh=ynz50sbnLtVD60g0VYWpDusoKzQ0mQPaAL2XkYVMsDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HuJ1cqUD4hjv5tbAr2mtMId6UdCBm8Svv4gK4Azisyph6GG0mZ2QKk05U1WzGhW2iBV+WOfm2g1/Z912eQT2KgmixqmfsWVPItbOG1EK2enqJlTp5RX4ZmYIN/OVdoINUVTTF7MeZ3iYnq4zbh6TOcIC28Z4BCf4T17vFDmHVu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2mktMTV7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2mktMTV7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4664C4CEE4;
	Thu, 17 Apr 2025 18:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914879;
	bh=ynz50sbnLtVD60g0VYWpDusoKzQ0mQPaAL2XkYVMsDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2mktMTV7Mfqzmkcz1/VvFFrGIZ/49Y8agrc5vBYPfpWBmXaPfFDgA/PnIK5SeGdvD
	 YT4+lcrg7mLoO6B1wYC0i2BOMTEzFsTWU4/5kp8I9gao6JGxejYvvLtZdcJbThworL
	 b1kDiAh/nPgKRwdxMF8CYXEsfIN1MSshdNM5GzJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Chiu <andybnac@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.13 360/414] ftrace: Properly merge notrace hashes
Date: Thu, 17 Apr 2025 19:51:58 +0200
Message-ID: <20250417175125.942830329@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Chiu <andybnac@gmail.com>

commit 04a80a34c22f4db245f553d8696d1318d1c00ece upstream.

The global notrace hash should be jointly decided by the intersection of
each subops's notrace hash, but not the filter hash.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/20250408160258.48563-1-andybnac@gmail.com
Fixes: 5fccc7552ccb ("ftrace: Add subops logic to allow one ops to manage many")
Signed-off-by: Andy Chiu <andybnac@gmail.com>
[ fixed removing of freeing of filter_hash ]
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ftrace.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3542,16 +3542,16 @@ int ftrace_startup_subops(struct ftrace_
 	    ftrace_hash_empty(subops->func_hash->notrace_hash)) {
 		notrace_hash = EMPTY_HASH;
 	} else {
-		size_bits = max(ops->func_hash->filter_hash->size_bits,
-				subops->func_hash->filter_hash->size_bits);
+		size_bits = max(ops->func_hash->notrace_hash->size_bits,
+				subops->func_hash->notrace_hash->size_bits);
 		notrace_hash = alloc_ftrace_hash(size_bits);
 		if (!notrace_hash) {
 			free_ftrace_hash(filter_hash);
 			return -ENOMEM;
 		}
 
-		ret = intersect_hash(&notrace_hash, ops->func_hash->filter_hash,
-				     subops->func_hash->filter_hash);
+		ret = intersect_hash(&notrace_hash, ops->func_hash->notrace_hash,
+				     subops->func_hash->notrace_hash);
 		if (ret < 0) {
 			free_ftrace_hash(filter_hash);
 			free_ftrace_hash(notrace_hash);


