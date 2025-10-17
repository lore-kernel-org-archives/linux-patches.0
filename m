Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A936432E15E;
	Fri, 17 Oct 2025 15:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713741; cv=none; b=DNocSlw7VagoJKfw1KoTXuVUGnquCS9+cXwKA65o+t2XyiB1BfVWV5mkFv8hGWcpv1e6XizeEeQ+BmmE/s1rJ+MzyAnb2KPMa0QvknfH1Fpylr8c0zg2MLarlPb20mcTTt4Qsh1sLp1kl0nvxP6DkGzUQkgxHyNrGxkL1+3ygAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713741; c=relaxed/simple;
	bh=m5VX3eBZdfhhToBc3r25l6J5vZgqy4golDebcYVYv14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PZ2EKMRHBr3Ebq2eGIpAN6Hec9EeOGKzNUNtspHI1h8S52/Fr5TCw4utyIg1NP0Q+wKjboJKYvGSanukAqfjT21RDE0tI51NlArQ1V+Ro1gLfOx8TelKDHaxVqHU62PnA9VyENwnrknh3tX2zugnLPZgb4zGEWdFtDRtk0inTUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dYkuxIrF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dYkuxIrF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFE8FC4CEE7;
	Fri, 17 Oct 2025 15:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713741;
	bh=m5VX3eBZdfhhToBc3r25l6J5vZgqy4golDebcYVYv14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dYkuxIrFsOOJ5sJi69spY0GNTb6cbDW+DUV+CuO1Fbmf+5U5Qtgiz26rjq92PZ/XY
	 cV54CzSyVK/xOejPrh7gk9mKgNwQn1fkjKFi2VHquQMqnD3Wh8GFYedRCRZasq8LMH
	 wvCCDSuuombW+BeQ/Jch5Nl0/NiW9rZPPlLduHxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksa Sarai <cyphar@cyphar.com>,
	Askar Safin <safinaskar@zohomail.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.6 103/201] openat2: dont trigger automounts with RESOLVE_NO_XDEV
Date: Fri, 17 Oct 2025 16:52:44 +0200
Message-ID: <20251017145138.531104720@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Askar Safin <safinaskar@zohomail.com>

commit 042a60680de43175eb4df0977ff04a4eba9da082 upstream.

openat2 had a bug: if we pass RESOLVE_NO_XDEV, then openat2
doesn't traverse through automounts, but may still trigger them.
(See the link for full bug report with reproducer.)

This commit fixes this bug.

Link: https://lore.kernel.org/linux-fsdevel/20250817075252.4137628-1-safinaskar@zohomail.com/
Fixes: fddb5d430ad9fa91b49b1 ("open: introduce openat2(2) syscall")
Reviewed-by: Aleksa Sarai <cyphar@cyphar.com>
Cc: stable@vger.kernel.org
Signed-off-by: Askar Safin <safinaskar@zohomail.com>
Link: https://lore.kernel.org/20250825181233.2464822-5-safinaskar@zohomail.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/namei.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1364,6 +1364,10 @@ static int follow_automount(struct path
 	    dentry->d_inode)
 		return -EISDIR;
 
+	/* No need to trigger automounts if mountpoint crossing is disabled. */
+	if (lookup_flags & LOOKUP_NO_XDEV)
+		return -EXDEV;
+
 	if (count && (*count)++ >= MAXSYMLINKS)
 		return -ELOOP;
 
@@ -1387,6 +1391,10 @@ static int __traverse_mounts(struct path
 		/* Allow the filesystem to manage the transit without i_mutex
 		 * being held. */
 		if (flags & DCACHE_MANAGE_TRANSIT) {
+			if (lookup_flags & LOOKUP_NO_XDEV) {
+				ret = -EXDEV;
+				break;
+			}
 			ret = path->dentry->d_op->d_manage(path, false);
 			flags = smp_load_acquire(&path->dentry->d_flags);
 			if (ret < 0)


