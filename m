Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49FC81A6803;
	Tue, 16 Jun 2026 16:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628434; cv=none; b=NkUBGe1IinrwgVvJ34VrpMH3Rx/n0bCk1zNlbOuumg97BFpZ22pQc6r3iQFpKJLHmhs5c9R9FPsrBj1SLKzGtP6n36z2vnYr7jBqaL3uzq5AqW06qSc75F33t5ItFaA9mmaeUKX/3z619IcFrGMl8gKsqZhKymvwT5wMrhsYFao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628434; c=relaxed/simple;
	bh=adFzjCA7qpgeD0oUz+g3lla0Vi/lwqCCkNTnP4NEVHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iLvK7sJm/jeB2cY2mg4kFesYMDjiSLOj2PGKfXWbQVYvq4+2VROcW3mziBmQ2nJIdeeiHMvZ6aGCPVMVkNZNbnQArVtX8h6SpGb3GBER5NtRgQp7rj/NN76DnTS6vJWle1zQ5JNbxdEpK1IYAAnW8cAX959VjinfYlsm97EW7fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yMABfbH/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yMABfbH/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24C071F000E9;
	Tue, 16 Jun 2026 16:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628433;
	bh=s2Sd6i0Qj9mwATNXK6ORYlYVD8uWI6xjKgxBCrUogCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yMABfbH/TgYE4MxYQeoqyxJ33P0Y5AMgYrfjoKmNOR0whTBusxid2RbD2WZAnWvPK
	 69fR6jzhojmS4Yq6Q4Pojae6YgeM6U0n9qJRx6kxPtpvFcifgyLe0Rcab2zlaV4amB
	 8cBSF7GMqF3rndOkVlRZP15hCv+6bkAPMuF8AluM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Farhad Alemi <farhad.alemi@berkeley.edu>
Subject: [PATCH 6.6 094/452] hpfs: fix a crash if hpfs_map_dnode_bitmap fails
Date: Tue, 16 Jun 2026 20:25:21 +0530
Message-ID: <20260616145122.757353433@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 974820a59efde7c1a7e1260bcfe9bb81f833cc9f upstream.

If hpfs_map_dnode_bitmap fails, the code would call hpfs_brelse4 on
uninitialized quad buffer head, causing a crash.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/hpfs/alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/hpfs/alloc.c
+++ b/fs/hpfs/alloc.c
@@ -372,8 +372,8 @@ int hpfs_check_free_dnodes(struct super_
 				return 0;
 			}
 		}
+		hpfs_brelse4(&qbh);
 	}
-	hpfs_brelse4(&qbh);
 	i = 0;
 	if (hpfs_sb(s)->sb_c_bitmap != -1) {
 		bmp = hpfs_map_bitmap(s, b, &qbh, "chkdn1");


