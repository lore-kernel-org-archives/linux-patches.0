Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 642762641F6;
	Thu, 17 Apr 2025 18:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914848; cv=none; b=ap0rlg6M5kh6gx7gPRha1ipIGTA2ZB8CkNPVf6RJ1sjXaRBgO2vMLS2ZPTA0BGHoZxuD046iyE9w2s2d8MzBp2n8D8RmvBrF3jJrklJHOH05tUYL9D8ecnsoBvFG7SEy+7ILiea0cmvBAJIUQzMlfcnAQ2JSl7zDeF9hVC5vbUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914848; c=relaxed/simple;
	bh=osPFs6t8lIpzKhlwNKom00EMIvXQCHdoIzl7blzj/ek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HhIVGQBG5aWklXgbqh1OmYgO1KhZq6EdQ+Ia/Tuy1M02/CW/gLKc96OBi3R1tRh9Jn4uixP6GdGW+iFj1aK4pZdrpy3M2xcZh7NmQsfYGPegqHW0lP7Bh6PWS4bL5nveLpVVSuOB3i/aalaGWO3D6r6gQsWJAqp7Z9W8dRk/TKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mQnIML4/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mQnIML4/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7A49C4CEE4;
	Thu, 17 Apr 2025 18:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914848;
	bh=osPFs6t8lIpzKhlwNKom00EMIvXQCHdoIzl7blzj/ek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mQnIML4/O3Dlp2O9QigjsTmL+b4MTvAWevKDGMlxuInFUr5cAsYn86RsImUaKT1Ad
	 nZQVoX9gbn2jP2OceApKVBhawPHmOk3N4kpl9gJUs7m6Si0ztY9Y63wN8809sJLMgJ
	 Zp023B+b7H+Fx6m3ZxugYmoAyLyIgob065yhqhxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>
Subject: [PATCH 6.13 351/414] dlm: fix error if inactive rsb is not hashed
Date: Thu, 17 Apr 2025 19:51:49 +0200
Message-ID: <20250417175125.551001670@linuxfoundation.org>
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

From: Alexander Aring <aahringo@redhat.com>

commit 94e6e889a786dd16542fc8f2a45405fa13e3bbb5 upstream.

If an inactive rsb is not hashed anymore and this could occur because we
releases and acquired locks we need to signal the followed code that the
lookup failed. Since the lookup was successful, but it isn't part of the
rsb hash anymore we need to signal it by setting error to -EBADR as
dlm_search_rsb_tree() does it.

Cc: stable@vger.kernel.org
Fixes: 01fdeca1cc2d ("dlm: use rcu to avoid an extra rsb struct lookup")
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/dlm/lock.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -784,6 +784,7 @@ static int find_rsb_dir(struct dlm_ls *l
 		}
 	} else {
 		write_unlock_bh(&ls->ls_rsbtbl_lock);
+		error = -EBADR;
 		goto do_new;
 	}
 


