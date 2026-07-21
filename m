Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 994B846C4C0;
	Tue, 21 Jul 2026 18:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658249; cv=none; b=V12njqTLoSnu+o6o772bTD+wrjUziC+svEMROAougb6w9AQX7FqgwAOx0fCS2nAvzpLV+AimM33DGDv08VNStHjJjvCtmh0aRVIF3zshQhryz7KG0o959qgiBYbrfpiret8b50Y24hCVEXPZog4M0g3ziGP03v2lRkNKVK0Jh7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658249; c=relaxed/simple;
	bh=R1EBEKVGmWcy4Jjy0TPXxI6LkOEnKnnLnEGL4CZ5q/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dr8EB0gfdossFUHZohFGHS21secWjzf1LIdTIpZZ4YaImRsAbsdjd5liCTMDF0D23/9PI0TL13DDVPI+xXd4hvYE/vPYVmmUCrNTTYhoCywJa+USZixFFxAaWkUv0mflE6L8boXUBmC0by1i3lx67jK5PDouvVTUf7LBGUWhCzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wuc2ktIy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wuc2ktIy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 129001F00A3A;
	Tue, 21 Jul 2026 18:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658248;
	bh=+sQvX5SEs40bMxiOK37E3lcX8RXpU4XJ4Kl8AFR5rOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wuc2ktIywb3Bbdh3t9+KTesrMDiILNwV9+wKKMUW3NJ6tYpLux7QeTgAUZxbaOJ9G
	 2WS8+2TL7Ia/8ndhZCzfc7WrcZpcbgFjyj5Cv/hZdbSdzliQ+PWKuVElMJn+SqY/q1
	 aepKeaVmipAc75QlcP8BrwdZzOTdCkJb8MBKk124=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Matthew Wilcox <willy@infradead.org>,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1019/1611] netfs: Fix folio state after ENOMEM whilst under writeback iteration
Date: Tue, 21 Jul 2026 17:18:55 +0200
Message-ID: <20260721152538.313298399@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: David Howells <dhowells@redhat.com>

[ Upstream commit b6a713fd34b9498ee2164d5d3e8460732a392efc ]

Fix the state of the current folio when ENOMEM occurs during writeback
iteration.  The folio needs to be redirtied and unlocked before the
terminal writeback_iter() is invoked.

Fixes: 06fa229ceb36 ("netfs: Abstract out a rolling folio buffer implementation")
Link: https://sashiko.dev/#/patchset/20260619140646.2633762-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260625140640.3116900-15-dhowells@redhat.com
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/write_issue.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/netfs/write_issue.c b/fs/netfs/write_issue.c
index 08bcdd0a871246..76614339554ea0 100644
--- a/fs/netfs/write_issue.c
+++ b/fs/netfs/write_issue.c
@@ -587,6 +587,10 @@ int netfs_writepages(struct address_space *mapping,
 		}
 
 		error = netfs_write_folio(wreq, wbc, folio);
+		if (error == -ENOMEM) {
+			folio_redirty_for_writepage(wbc, folio);
+			folio_unlock(folio);
+		}
 	} while ((folio = writeback_iter(mapping, wbc, folio, &error)));
 
 	netfs_end_issue_write(wreq);
-- 
2.53.0



