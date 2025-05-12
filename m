Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 424551E505;
	Mon, 12 May 2025 17:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072119; cv=none; b=hCJesoAGUkNA/Yc67duzDYy8/YLfP5CHf7wo3j3syrGg1FcILBLSktAIBBKuSjMuIQzS7pKGq9ijK6wCa/zmDu/4EbM3SjU6GuIJ39W7AMYxDyu3pZSVoObugsh0oDRNNUJ5POV157T03uHGkkdHmA6Jx9ybTwegArRlq7a3yI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072119; c=relaxed/simple;
	bh=+aVbTpES5CrNr/gS0wvjvxuDta2czleIPdB69sSy39Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eDhzSm+mBCJ7Vl+m/cEJ9S/7vRmdsCKzQpdiJdDSbN79AA/45D5hIy6v2gyGUHMtTqAEFQA4+pcvldqHDrY/qR5LWqclpRIKrvnHkbyOtnomEYjA4w9gaaqv8qGlMeD9+Kl1d8OsiVB/pbDhLfSB+yIOO7KFgLhCpTWz0VYhN7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r4gzuI76; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r4gzuI76"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7085C4CEE7;
	Mon, 12 May 2025 17:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072119;
	bh=+aVbTpES5CrNr/gS0wvjvxuDta2czleIPdB69sSy39Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r4gzuI76JNK5+flpL+qP2BOYnWnGH1yGIqQFtEVFUU6y/dnEw+9FNHPtNAc7qYZX0
	 Pf3ZYL7tkB51dK2uqGjv/YIAx3IpXysgndDxw0i7hvcn6865v/F2R1u7+Uh5GSuICu
	 XxWAamm4aVeL7wiP/qvmsH5pyfRjaQ+Av1/Ck9Zg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Tinguely <mark.tinguely@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Changwei Ge <gechangwei@live.cn>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Mark Fasheh <mark@fasheh.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.14 129/197] ocfs2: fix panic in failed foilio allocation
Date: Mon, 12 May 2025 19:39:39 +0200
Message-ID: <20250512172049.646359574@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Tinguely <mark.tinguely@oracle.com>

commit 31d4cd4eb2f8d9b87ebfa6a5e443a59e3b3d7b8c upstream.

commit 7e119cff9d0a ("ocfs2: convert w_pages to w_folios") and commit
9a5e08652dc4b ("ocfs2: use an array of folios instead of an array of
pages") save -ENOMEM in the folio array upon allocation failure and call
the folio array free code.

The folio array free code expects either valid folio pointers or NULL.
Finding the -ENOMEM will result in a panic.  Fix by NULLing the error
folio entry.

Link: https://lkml.kernel.org/r/c879a52b-835c-4fa0-902b-8b2e9196dcbd@oracle.com
Fixes: 7e119cff9d0a ("ocfs2: convert w_pages to w_folios")
Fixes: 9a5e08652dc4b ("ocfs2: use an array of folios instead of an array of pages")
Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/alloc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -6918,6 +6918,7 @@ static int ocfs2_grab_folios(struct inod
 		if (IS_ERR(folios[numfolios])) {
 			ret = PTR_ERR(folios[numfolios]);
 			mlog_errno(ret);
+			folios[numfolios] = NULL;
 			goto out;
 		}
 


