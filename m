Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2F902210DE;
	Thu, 12 Dec 2024 16:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022746; cv=none; b=Z6dfpLh1/pDFQZLY63GULkixd1DRnJhMog/XYWLqQqgCj8WmB/d6TuO9h4WZJV395wb3P+2/hDtUr4wEq4Wp7gukbJ4HkN09MlD8m7SCF+GRI2es0QXyr9HYEQP5jIcH95yBZgCkdS0mwjPDFmKuGSUhLdviTaIePCtjshyMRFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022746; c=relaxed/simple;
	bh=oOk1dHVQ7zkY+83zwMxtWE7C4OQ3wO4jFzqHnsZdThw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uZG4QL5oLiRLNhaMMsT5o3qn58B+VAp+hkIu283hlnH1Zqr/1GjFASm2qoPgOetcui14iAU+mBX/jY5tlkDQLjw1e3AW5skdfikGIcVvnlOZvYUlathn+tqHLIoEmBlPi2bjGgIO0s4eYDNQvnDDZ3rc3PDexQMknRJ/LRC49nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fMwoHAce; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fMwoHAce"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29950C4CECE;
	Thu, 12 Dec 2024 16:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022746;
	bh=oOk1dHVQ7zkY+83zwMxtWE7C4OQ3wO4jFzqHnsZdThw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fMwoHAceFSWu8Mvdn9+t4Q96D16h6ftwgrd/MofwvaBrc3RSYZyFVoIGOxFKdRAAu
	 oozinsv7RBYtGbCVTzad+Ad5W4DpW+lGmxhVTjz515Ua4ZuKDkCyJMHrDwbKY+TrtD
	 9igbeVPeqqdi0xWVVIAnWZiUyDhKyvL68U79H/VQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+01218003be74b5e1213a@syzkaller.appspotmail.com,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 5.15 318/565] exfat: fix uninit-value in __exfat_get_dentry_set
Date: Thu, 12 Dec 2024 15:58:33 +0100
Message-ID: <20241212144324.173064267@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

commit 02dffe9ab092fc4c8800aee68cb7eafd37a980c4 upstream.

There is no check if stream size and start_clu are invalid.
If start_clu is EOF cluster and stream size is 4096, It will
cause uninit value access. because ei->hint_femp.eidx could
be 128(if cluster size is 4K) and wrong hint will allocate
next cluster. and this cluster will be same with the cluster
that is allocated by exfat_extend_valid_size(). The previous
patch will check invalid start_clu, but for clarity, initialize
hint_femp.eidx to zero.

Cc: stable@vger.kernel.org
Reported-by: syzbot+01218003be74b5e1213a@syzkaller.appspotmail.com
Tested-by: syzbot+01218003be74b5e1213a@syzkaller.appspotmail.com
Reviewed-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exfat/namei.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/exfat/namei.c
+++ b/fs/exfat/namei.c
@@ -356,6 +356,7 @@ static int exfat_find_empty_entry(struct
 		if (ei->start_clu == EXFAT_EOF_CLUSTER) {
 			ei->start_clu = clu.dir;
 			p_dir->dir = clu.dir;
+			hint_femp.eidx = 0;
 		}
 
 		/* append to the FAT chain */


