Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F3C250C09;
	Thu,  3 Apr 2025 15:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743693890; cv=none; b=fR/RtwNEFYboLonqI+owO5opmPQUtNGUZSd4cIIJAS40CPFxlmNiwhFVHQzrgk3E76ttzEpX+ILPtNYPGtuMQQCVlXxq62+udzWOR8EKay7pc/0/b7l57mt2IVhYojfSR0IKoM9ttcaPbgINYfG/SZt89x7RdecxYbs+n3ui+O8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743693890; c=relaxed/simple;
	bh=7JcZYiEK+0oYqdy2Thoq0SQGD2xBL9Gxd4C6M2YC7xg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QmVsHV91fN1aTTqgXUMdyCLhd9lDKbJ4AVuM3nRxbsQrbj3Zi5GHpJvjirngox0AM0xruk6vLsTVFGfnL5dTKyR8MRA+fsg0i5WhV7wYx4QqiKWPDgiDbvMm6J/ZbfL2+871v62iyYCYnMIfNUIvNXfx91+ToORoKUcIHqvxUks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pdGdlwf7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pdGdlwf7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B44EFC4CEE3;
	Thu,  3 Apr 2025 15:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1743693890;
	bh=7JcZYiEK+0oYqdy2Thoq0SQGD2xBL9Gxd4C6M2YC7xg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pdGdlwf7Ct7WYfG2ZDWYAuMnE45KdLhaulA8znpIBAnNxWl+Ys3lEMtQwMn8zPnCr
	 XflScUffp54uDWnpSQjy5aLjoBYJO5UI0XmH16WNGy46AKSdKZzC9JN00bWNlBosR1
	 urX253ivZJggYuDCDIF6y0mpQNYh4TKaY/8CGcaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jur van der Burg <jur@avtware.com>,
	Scott Mayhew <smayhew@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Salvatore Bonaccorso <carnil@debian.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.12 04/22] nfsd: fix legacy client tracking initialization
Date: Thu,  3 Apr 2025 16:20:14 +0100
Message-ID: <20250403151622.170971525@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250403151622.055059925@linuxfoundation.org>
References: <20250403151622.055059925@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Scott Mayhew <smayhew@redhat.com>

commit de71d4e211eddb670b285a0ea477a299601ce1ca upstream.

Get rid of the nfsd4_legacy_tracking_ops->init() call in
check_for_legacy_methods().  That will be handled in the caller
(nfsd4_client_tracking_init()).  Otherwise, we'll wind up calling
nfsd4_legacy_tracking_ops->init() twice, and the second time we'll
trigger the BUG_ON() in nfsd4_init_recdir().

Fixes: 74fd48739d04 ("nfsd: new Kconfig option for legacy client tracking")
Reported-by: Jur van der Burg <jur@avtware.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=219580
Signed-off-by: Scott Mayhew <smayhew@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Tested-by: Salvatore Bonaccorso <carnil@debian.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4recover.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -2052,7 +2052,6 @@ static inline int check_for_legacy_metho
 		path_put(&path);
 		if (status)
 			return -ENOTDIR;
-		status = nn->client_tracking_ops->init(net);
 	}
 	return status;
 }


