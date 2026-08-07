Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6808138C2C0;
	Fri,  7 Aug 2026 15:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116972; cv=none; b=kv3XKm3zKP10tSm1DFStd8DByLvZyicbu5wXvSeuB2FBabSzcVhDvisXbAiaqKJPzwSuvcfsGDhxkAMQbZvmGgVQShVkQA3qEibewLr3hgXIR+IetsP2d03VBDoOQ0CmI4Qf2fE/UOw5iodqKYwb8OWAXJZpZHQ+aKH4UKoAaFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116972; c=relaxed/simple;
	bh=/8Q5PPXRPgUCPFu+01SuKqjQEvZ6OX+dRmEfmMmZa/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mQdAYxSuZevtxZ55RHux9sJRRj9z3z/qr/IUJvk2yjqjgNHwP0A73RSN2cMpXTFo2tsjGfyAJETV0wH66tWs2pUOxQKCohV99kav4fMGphggYfxV5AAoqYsk6cR6SuXT/2WpW+1KhAHApf7AqvcflbQg6dyI/5mozfapF68Xpbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OEi43vcJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OEi43vcJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C96D21F000E9;
	Fri,  7 Aug 2026 15:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116971;
	bh=ZAkzz4vfadP4u24nDit6BggweivfoBxY2fEQbJCfpno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OEi43vcJEjAkKoFkdhskEkorvMw7/tKN6Jg/T3mjfaWLZ8xexu6EUXLSTott/FG1s
	 hLqK/hxIO+0AgWytHIrVji1TJKN0fmB+O3m55VpSNCcoM8seGxeqP7n5Y1v+UCBz/m
	 igFXNGx6fJwchFrQjtA1WORS1M78C26OcToau9zw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 118/438] netfs: clear PG_private_2 on copy-to-cache append failure
Date: Fri,  7 Aug 2026 16:35:14 +0200
Message-ID: <20260807143430.509317365@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

From: Yichong Chen <chenyichong@uniontech.com>

[ Upstream commit a81fc9266e1c5fef9ccf675a9b44b2f4ab464923 ]

netfs_pgpriv2_copy_to_cache() marks the folio with PG_private_2 before
netfs_pgpriv2_copy_folio() appends it to the copy-to-cache rolling
buffer.

If the append fails, the folio is not queued for cache writeback, so
the PG_private_2 state and its reference must be released immediately.

Fixes: e2d46f2ec332 ("netfs: Change the read result collector to only use one work item")
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260727130716.1099906-2-dhowells@redhat.com
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/read_pgpriv2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/netfs/read_pgpriv2.c b/fs/netfs/read_pgpriv2.c
index a1489aa29f782..7eacc58abadb7 100644
--- a/fs/netfs/read_pgpriv2.c
+++ b/fs/netfs/read_pgpriv2.c
@@ -54,6 +54,7 @@ static void netfs_pgpriv2_copy_folio(struct netfs_io_request *creq, struct folio
 
 	/* Attach the folio to the rolling buffer. */
 	if (rolling_buffer_append(&creq->buffer, folio, 0) < 0) {
+		folio_end_private_2(folio);
 		clear_bit(NETFS_RREQ_FOLIO_COPY_TO_CACHE, &creq->flags);
 		return;
 	}
-- 
2.53.0



