Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322A435C1A6;
	Thu, 20 Aug 2026 15:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239010; cv=none; b=airT3eJYzhZfNLN0BgRk6CzcPOzoPr0MAlDHwzyUdu3k6wPAnlOQeS8vrvOt6OnZHOhwiY9kxNaxb5bqSM2B49btWznLX1RBrjrEBfDMWIDE6APpiQyJ8Km0OvLFiB1Pu9DDV4gwkK8rMKr5MWid6wcORzDU1mIa+f2x2Le5v14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239010; c=relaxed/simple;
	bh=2QIqM/dAXE+dsYTjhCM9AkrsOpmrgHINL+FyLryvoSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ktM+IvOErBtADYpDOTj1DRTPI677/GdSSjtHwOVL59l2EpToSbKBeENQfyP2rxAbcT7UedHdrONEWhmbA3u9aWhyfoW//e4qQmOWvi7BHPoiDH/8I+g4hoPZBTMXMKCSyiJ3illfOgycolZKtLk5qo6el+yZFMnILKm3jbC3y9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UK5jGmus; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UK5jGmus"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D6651F000E9;
	Thu, 20 Aug 2026 15:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239008;
	bh=jU9BCB+uXqrONupT9PsXF3bFrLMTE5bKxxhnMDc29Fc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UK5jGmusZu3uRXOIlTi8pwptKYAhiRJ10UkynO26wC9eto9fnThxHDhdmJYBPxxfB
	 /P6DgoM4fokd+UVgRuC6Putlza1AOLsCLlExFe+FUF7ZlHAPFt8fDViB73yY3qTimw
	 FkXE4yQum3LMyNSYSLoeZ06s+BAtLEZf+bgMnuh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 116/217] xfs: load next_agino from the correct xfarray in xrep_iunlink_relink_prev
Date: Thu, 20 Aug 2026 16:54:44 +0200
Message-ID: <20260820145241.229421385@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 6b9cd540138a06660a843a519facc147060acbef upstream.

LOLLM notices that xrep_iunlink_relink_prev has the comment "set the
forward pointer..." but then loads the value from the xfarray that
stores pointers to the previous inode in the unlinked list.  That's
wrong, so fix the variable access.

Cc: stable@vger.kernel.org # v6.10
Fixes: ab97f4b1c03075 ("xfs: repair AGI unlinked inode bucket lists")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/agheader_repair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -1626,7 +1626,7 @@ xrep_iunlink_relink_prev(
 		want_rele = true;
 
 		/* Set the forward pointer since this just came off disk. */
-		error = xfarray_load(ragi->iunlink_prev, agino, &next_agino);
+		error = xfarray_load(ragi->iunlink_next, agino, &next_agino);
 		if (error)
 			goto out_rele;
 


