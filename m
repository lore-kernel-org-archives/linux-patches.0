Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA9A3D9027;
	Tue, 21 Jul 2026 17:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653622; cv=none; b=YNcGN3s/xn/ji9K8FpnaiwxkW+qjb8gXE43Pg3UA1rorQ5d/Eh/th1HY1yyyrh6olNIccc0i3SoicG5IabRo5p3OxrLYBQdYhIkvLPPSl9l81UdmJ/s0qZEqW5KOyQFtJxebLh0JyzUnfLu3hLOPcTDVJts6vZZvm7TZj1pMUus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653622; c=relaxed/simple;
	bh=p+09jr1C5TBg3ArItH+5teXh/XyN6JvD68QPy4dwxXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BBcfAeNYJnoaMeRx5kTIkf9uGFHwbnX4dipL0kDwxCRN8R3akj1WHnwpkSKVgqOP9gYjWpYBDJam5KxABSmQDWYNPI+m4H6miTcak26OaJeGkyWmH+75EI4F8zNzmZtjhIt2VCOwIamuDvMpctGz9V1hPRHN/Ws62Eh3zYhQmZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=icWRlR+F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="icWRlR+F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA9C01F000E9;
	Tue, 21 Jul 2026 17:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653621;
	bh=kgTwMwaR0A8Rvbc7xBwJ0Bsu54lZgL8w1+cA9mnS1Wc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=icWRlR+FforhwPVc42n+LaTw+d4pL0drzTpwwSjQvajUPupOkNVlECaKZ4mO+UuUv
	 qIv5dlVmcfIP6EeewXnD/H3+0Q50BrHdird/OlH+9AP1eRUbU/Gh1i+BSfr140M82r
	 TFnGNgVbwdEVoBW0ZbWxonGYRognzS5JoVHC3pOA=
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
Subject: [PATCH 7.1 1397/2077] netfs: Fix folio state after ENOMEM whilst under writeback iteration
Date: Tue, 21 Jul 2026 17:17:50 +0200
Message-ID: <20260721152625.762323937@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index cd0c8b3297ee0a..d0d884731dc5d7 100644
--- a/fs/netfs/write_issue.c
+++ b/fs/netfs/write_issue.c
@@ -588,6 +588,10 @@ int netfs_writepages(struct address_space *mapping,
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



