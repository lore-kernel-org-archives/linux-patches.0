Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C919D47F774;
	Thu, 20 Aug 2026 17:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787246976; cv=none; b=b0zmbnXHCDXRTkZwvdSSCSdksv+7qlzM+YFzrMSaXmtfgkdChiYmFUe7QB3hR23y02H5o240ZHXnmNi0qZuJ7DQ+h7hNnZv2oAdIj+evhpnhrFG0z24Llcl6XMQUvedfM+qHs9FQUGjfZmEjPHmcKrfQv9OFLehF7EFdD5rxCj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787246976; c=relaxed/simple;
	bh=5uFbDgscuzi+MWBmDRcaNetf6C1mylN10mosluOl/34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pbMy6gaqYUs4WjcAbhXk6OSqFrOOTWRue4NrqEQIwh5RbidpyGo0Aq3Fda+ELyw3GpcM7MpoaqRvq2IgLLFMtfSvAxh7WkwCkJ2z70Avjemui7RtySeD4gsSjZs66AwoibxubK/nhjxt9hCkzp3UuovuQ+N70flktYpVY6ykM9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JSDvSV2Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JSDvSV2Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3201D1F000E9;
	Thu, 20 Aug 2026 17:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787246975;
	bh=ToB1Ipot+WWjsuw5pHq8s5Z6dM9/21aPG++uKMLOKX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JSDvSV2Y5pTVdbDHVusI6pQJ4qmMUbko1tVeJD6ZIhSxG7ksBuulfdw7fzdN+ppHz
	 POj+iFp2IRF+7ncjO+/wAC6V36RQnAm0bUrw0paB8EwmLQxQeJukHyMTIeyXaev00T
	 aNLUFJfGKhftv8yiUhaDjfbCnu2pViAd8Y/4y0eo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 099/220] xfs: load next_agino from the correct xfarray in xrep_iunlink_relink_prev
Date: Thu, 20 Aug 2026 16:54:49 +0200
Message-ID: <20260820145226.457563394@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1634,7 +1634,7 @@ xrep_iunlink_relink_prev(
 		want_rele = true;
 
 		/* Set the forward pointer since this just came off disk. */
-		error = xfarray_load(ragi->iunlink_prev, agino, &next_agino);
+		error = xfarray_load(ragi->iunlink_next, agino, &next_agino);
 		if (error)
 			goto out_rele;
 


