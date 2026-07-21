Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0CA8305E3B;
	Tue, 21 Jul 2026 22:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671320; cv=none; b=OjacLnyBzh9GdrxiEAGNeW8fhc+yVp+op2sFVyWFzhIaqKEGayIbFitTAFiCp1gSDM7wWJSDtwMwKoWvUTNSSC99Wz6boDY3hdh17eLb5ptC3n5WNXP1OwSV5VRw1iCkM3FoOkHvxEswAweZjEy3ztfSp9aRShNiseMThv/e04U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671320; c=relaxed/simple;
	bh=5nPF0ckQUcmoSU201B/AG+pvf4cRNmVQtqpS5KT7Dh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V3Oi4XCqz02VIvsVbKADDzzyDw6wASMXWR/PVg/md46AFBARY83wlv0vix8IOxzlntTNoMHIuWfjLLgm/htMUTFdUMlAmiq360nltAoCdY6PmK6ZcHwVD9NNtefx1HCm2vbF4x63SPGSbhj7OlMZe8MRZ7kQp2VmNayDP353Bsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b94gcXvB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b94gcXvB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D88B1F00A3A;
	Tue, 21 Jul 2026 22:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671318;
	bh=6chLkqReQWfT3U7CR4EYD0pGqKtqTmw/G/4Q8B+LTQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b94gcXvB3G74Tp2UisiG90x5BXDc9M3dfhH4T/WqajT267YaOFioX8piv+61pKugd
	 UPIasGu1FNH52CqsuZK/vgCWscR3ln3vvzGe7oVZjQ6x63N0zdwPF/615mfoibxczG
	 ihqeOg6laBvIGiNxfXaLZJFLsaw3zDh1LQ4Uc/rk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trondmy@kernel.org>,
	Benjamin Coddington <bcodding@hammerspace.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>
Subject: [PATCH 5.15 174/843] NFSv4: include MAY_WRITE in open permission mask for O_TRUNC
Date: Tue, 21 Jul 2026 17:16:49 +0200
Message-ID: <20260721152409.933006437@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Coddington <ben.coddington@hammerspace.com>

commit 5140f099ecd8a2f2808b7f7b720ee1bad8468974 upstream.

POSIX requires write permission to truncate a file, so an open() that
specifies O_TRUNC must be authorized for write access regardless of the
O_ACCMODE access mode.

nfs_open_permission_mask() builds the access mask passed to
nfs_may_open(), which is the local authorization gate for OPENs the
client serves itself from a cached write delegation via the
can_open_delegated() path in nfs4_try_open_cached().  The mask is
derived from O_ACCMODE alone, so an open(O_RDONLY | O_TRUNC) against a
file the caller cannot write requests only MAY_READ and passes the
local check.  The OPEN is then satisfied locally and the truncation is
issued to the server as a SETATTR(size=0) over the delegation stateid,
which the server accepts under standard write-delegation semantics.
POSIX requires that this open fail with EACCES.

Include MAY_WRITE in the mask whenever O_TRUNC is set so the local
check matches the access the server would have enforced.

Suggested-by: Trond Myklebust <trondmy@kernel.org>
Fixes: af22f94ae02a ("NFSv4: Simplify _nfs4_do_access()")
Cc: stable@vger.kernel.org
Signed-off-by: Benjamin Coddington <bcodding@hammerspace.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/dir.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -3026,6 +3026,8 @@ static int nfs_open_permission_mask(int
 			mask |= MAY_READ;
 		if ((openflags & O_ACCMODE) != O_RDONLY)
 			mask |= MAY_WRITE;
+		if (openflags & O_TRUNC)
+			mask |= MAY_WRITE;
 	}
 
 	return mask;


