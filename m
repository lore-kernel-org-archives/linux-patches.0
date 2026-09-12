Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CADA477E57;
	Sat, 12 Sep 2026 11:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214327; cv=none; b=CVBLjRnWQFxN35rgx6wqMW1C6hDDqZNbeVbWMtIgVVbeACjqi4OkuxLGfUGkTAUdVppN1jlBCAi1rukgoHgaECTzPaUFkZzacJgKyFP1ov42qUl8w9NSCzqUZnWDAgP8yWtc6wovSCDRpKKcCICH0UknOiO6ATrMyZVy5bn6hq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214327; c=relaxed/simple;
	bh=reccbOoOm0uX2euajUm/S+xriZj72JexA1jF3MMzZOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W7Z+GPx7QWbjSQ9lNnY4POB2RYGd8lcJtL3DjLivMq4YhXfjlUo5GqiHM9iLILNJkyACILOZHXnK07V+/BrFNZTuuf+rxqhJFw3xWKMku3TAD4KDW4nlpEsbrWKJwVFA5NFBU7CRQNCt43ahCX3UGWhHFTKhBySqU4o0tNtRjw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tpjM2OXo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tpjM2OXo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72B4E1F00893;
	Sat, 12 Sep 2026 11:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214324;
	bh=Aqs41b8oSj+DwUI0j8FNjD6wy1FGhn0ilVxEEAdWRnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tpjM2OXoR2t7fSeg7g9rZpaBv4tCOp3blzWGyJz6fU1jCVHTYzpigXrKMO+GhchU7
	 YOzEuseF2Ig8ER7c7xOFxeXSroa2Pvo5wdHCAdwfcY13eYjtyHFrZvx8aNsxKNRIur
	 BeC6P1F4vcqpRPHe+BOnpsmz0460YO/R2+LCBD6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Deepakkumar Karn <dkarn@redhat.com>,
	linux-afs@lists.infradead.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Alexander Martyniuk <alexevgmart@gmail.com>
Subject: [PATCH 6.12 0286/1376] afs: Fix leak of ungot volume
Date: Sat, 12 Sep 2026 08:45:12 +0200
Message-ID: <20260912065613.922042138@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: David Howells <dhowells@redhat.com>

commit d672c276f685a540ed2b2a8bafaed4650a89022c upstream.

Fix afs_lookup_volume_rcu() so that it doesn't leak a dying volume if
afs_try_get_volume() fails.

Fixes: 32222f09782f ("afs: Apply server breaks to mmap'd files in the call processor")
Closes: https://sashiko.dev/#/patchset/20260609081738.770127-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260622090856.2746629-17-dhowells@redhat.com
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Deepakkumar Karn <dkarn@redhat.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Alexander Martyniuk <alexevgmart@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/afs/callback.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/afs/callback.c
+++ b/fs/afs/callback.c
@@ -138,6 +138,7 @@ static struct afs_volume *afs_lookup_vol
 
 		if (volume && afs_try_get_volume(volume, afs_volume_trace_get_callback))
 			break;
+		volume = NULL;
 		if (!need_seqretry(&cell->volume_lock, seq))
 			break;
 	}


