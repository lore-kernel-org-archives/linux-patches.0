Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F8323EA74;
	Thu, 12 Dec 2024 16:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019958; cv=none; b=oVot+lajvAZ6HQY04++OUnM/Bwz//CkLO92BKOaxQLz77TG7yXw1bBzOAcRLhpNZBRBXONn6NOAmjugafcR6xL49LEiCVT1YxbG+2/497ge51wgoaSxPe9qzo6M+eq/aGvfWIAEFPiIbgFRqrY2IpfnOijG+NCWLze73I1yuX5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019958; c=relaxed/simple;
	bh=3s/QD1zigeFqP8z5iDkYvynncDAaKXk0rBemo6jQsLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ec5ZbL6Z/E/tlelNWE0IjKrGxPTfa9AGIer7fAMK5v4AuhX7oM+izJ7U4JKDU7V0f/B0SSiXPD1zdOZRkK45wnuj2fWh3IMxc0V7x0NIxvf9K9+V52Yvyh5A8cJ0CWZ1v04yVcauqPw9mBeBeaQqUeZKdyLNrb7lhhoZ5onKhlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MymdMYoQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MymdMYoQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F11AAC4CED3;
	Thu, 12 Dec 2024 16:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019958;
	bh=3s/QD1zigeFqP8z5iDkYvynncDAaKXk0rBemo6jQsLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MymdMYoQnqL10IOt9EsA28VBT/cmCrW69iuyXxn07JHer/yB1EpRMJCZsDQm/G+72
	 /RhjOSnNj4rIglNiatMcOG+DBmD+EY9f3bn5LdTvyYcEXFhA28hqeDcv3xyyYl3iQY
	 fJaJ8+pzbVSvhKivJ8d9ekdcQzcz3gJOAGK//Pbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	lei lu <llfamsec@gmail.com>,
	Dave Chinner <dchinner@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Bin Lan <bin.lan.cn@windriver.com>
Subject: [PATCH 6.1 341/772] xfs: add bounds checking to xlog_recover_process_data
Date: Thu, 12 Dec 2024 15:54:46 +0100
Message-ID: <20241212144404.004947255@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: lei lu <llfamsec@gmail.com>

commit fb63435b7c7dc112b1ae1baea5486e0a6e27b196 upstream.

There is a lack of verification of the space occupied by fixed members
of xlog_op_header in the xlog_recover_process_data.

We can create a crafted image to trigger an out of bounds read by
following these steps:
    1) Mount an image of xfs, and do some file operations to leave records
    2) Before umounting, copy the image for subsequent steps to simulate
       abnormal exit. Because umount will ensure that tail_blk and
       head_blk are the same, which will result in the inability to enter
       xlog_recover_process_data
    3) Write a tool to parse and modify the copied image in step 2
    4) Make the end of the xlog_op_header entries only 1 byte away from
       xlog_rec_header->h_size
    5) xlog_rec_header->h_num_logops++
    6) Modify xlog_rec_header->h_crc

Fix:
Add a check to make sure there is sufficient space to access fixed members
of xlog_op_header.

Signed-off-by: lei lu <llfamsec@gmail.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Bin Lan <bin.lan.cn@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_log_recover.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2439,7 +2439,10 @@ xlog_recover_process_data(
 
 		ohead = (struct xlog_op_header *)dp;
 		dp += sizeof(*ohead);
-		ASSERT(dp <= end);
+		if (dp > end) {
+			xfs_warn(log->l_mp, "%s: op header overrun", __func__);
+			return -EFSCORRUPTED;
+		}
 
 		/* errors will abort recovery */
 		error = xlog_recover_process_ophdr(log, rhash, rhead, ohead,


