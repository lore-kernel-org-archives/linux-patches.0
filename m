Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828906;
	b=5Lbz6efaoRkPCMoN/63x7vjXdzobRZCvURXAbIPAr2QLxZ9C7sqUrJKLqhQLhTU5Xir5
	 Aki2NW2asTPA8FBlopHEsw5k5J+3P4WRImP8f6/5MuLXLpbddITWTRUTZyo3ZbXc7Q8Bp
	 rm+vrDICfKZJKR1DOuMprolVipEb4EkIMkSbNjtDH4xk5XAajXxjVjCABdILJrN5ungy6
	 Y3S+kKLDmriQ4bTzvCrIbFwAKHx/8Ntz2sfR3J9V9Zl0MCnqIsEvci9EmKa84p/ow5CX8
	 ri2a4Ws/9vTlvJMFVW1dWh8r84oN5iGO3sQh1lqVnwyNWTWZecmqWQscVYjtmyt51Sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828906;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EodELLwV+ngOJHfWoRPYejGmscy+XWbhKBPKOuHrJeU=;
	b=CbAYYDG4D+PbAExONteUrZk+mu5S2rPnCuNo760fdwqtHU6EAZAFiVGjDpT7f234vhfs
	 QeXiCV5y6Bg9OALyfMvrLKQl3oBizouk4G4WOQld6+8gtj29z710PQoyeAHKqAGctShL8
	 6ach8bKh+tgmUvB4YWBpemW0MppnW6Sag1wI/ECUF2RM+0zwX4gowcJ7/Wy4OzK0oEnPc
	 Ub1NLqwnMgNAYGh55CpvytNS+chvDtTqt1vCAf3OnTLGjgD0L2VAOh83hho8ft7tUlWs5
	 lwIPCimndYuYE1tf0m15Rb+CBwHDk0b6vvE1YAd/dvAAtsZ1+nrpV1demnjhh39SqRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NwvK26qt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63BE16070303;
	Wed,  4 Nov 2026 21:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NwvK26qt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 060621F0093A;
	Wed,  4 Nov 2026 21:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828906;
	bh=EodELLwV+ngOJHfWoRPYejGmscy+XWbhKBPKOuHrJeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NwvK26qttrQjWJnHDghA/i4UmFN3BkJb3ZXI854syAmROk2AijBgv37YR9Xf3r+8V
	 UMd+gwcb+fZ8paxJVDk2gjEWibYzB4GQqUU9gb5/kKg6WbuzuTA43xSBrLuQ3CHQWW
	 uvCNgpNPr9j9osvyskVt22pB/49jeCuItt1dn/ys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 318/547] xfs: dont proceed with xattr repair if the live update fails
Date: Wed,  4 Nov 2026 16:08:22 -0500
Message-ID: <20261104211047.255487315@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 833f98b3be45bc7c6ce4c87bdc4892f546ab72ee upstream.

LOLLM observes that we ought to make one last check for failed live
updates before replacing the xattr structure.  Let's be cautious here.

Cc: stable@vger.kernel.org # v6.10
Fixes: e5d7ce0364d8ee ("xfs: replay unlocked parent pointer updates that accrue during xattr repair")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/attr_repair.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -1477,6 +1477,9 @@ xrep_xattr_rebuild_tree(
 	if (error)
 		return error;
 
+	if (rx->live_update_aborted)
+		return -EIO;
+
 	/*
 	 * Exchange the blocks mapped by the tempfile's attr fork with the file
 	 * being repaired.  The old attr blocks will then be attached to the


