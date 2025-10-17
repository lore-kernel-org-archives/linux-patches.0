Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DABD33370E3;
	Fri, 17 Oct 2025 14:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713182; cv=none; b=Q0k5yb/d3PpNgG/dLanGIwOGMQRT7zcmEPnhWclbXrAfUlNmRzzbcpbrj1WiT7bvzOL+sc8VWdLY5vVFmVTh73PsPqVCZLGy6kw3m1fVtwiH0tiKMVxuQ92w4GtJhTm9eJ4uyjCzy5cmJoR/i0B2/3r8mecjbP08i80Sts3mWPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713182; c=relaxed/simple;
	bh=K1M1YDy4WUfB0TA8Unur8yWEk7DTd2Q7P7F+vFFPaWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tHs0YGjyLVwIdm0tnQ8E/c7iokAiKSlO3UBd9CUY7qHqX74CcyebO76xsLnhVWE3yYP7Lh8FrUZrVgL0dxRpzeTYf8ecHJCkrnIyfiJznCusBKR7AvUh0KRX2VblO8s8wgPhJcIC4UBRYJ/7nIOaOS5j1+cJPuDmP3qXP6zDpI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yb8bBEBp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yb8bBEBp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65987C4CEFE;
	Fri, 17 Oct 2025 14:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713182;
	bh=K1M1YDy4WUfB0TA8Unur8yWEk7DTd2Q7P7F+vFFPaWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yb8bBEBpQTADb77Fwj177ps5o4H6MbPmB4+MmCGhvxSRxeKOUJKWinILPcePw+ZAI
	 rneNrJH+GwNQXAelllnQsbthRaJgOuvqaAJPZongnCQo3LJ1OJ0Dsd3ZysZaiiydpV
	 gv/KKP9HeGVrUC827wVEnwBcqdF+ymjurypFiDyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.1 076/168] fs/ntfs3: Fix a resource leak bug in wnd_extend()
Date: Fri, 17 Oct 2025 16:52:35 +0200
Message-ID: <20251017145131.828217064@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

commit d68318471aa2e16222ebf492883e05a2d72b9b17 upstream.

Add put_bh() to decrease the refcount of 'bh' after the job
is finished, preventing a resource leak.

Fixes: 3f3b442b5ad2 ("fs/ntfs3: Add bitmap")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/bitmap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ntfs3/bitmap.c
+++ b/fs/ntfs3/bitmap.c
@@ -1374,6 +1374,7 @@ int wnd_extend(struct wnd_bitmap *wnd, s
 		mark_buffer_dirty(bh);
 		unlock_buffer(bh);
 		/* err = sync_dirty_buffer(bh); */
+		put_bh(bh);
 
 		b0 = 0;
 		bits -= op;


