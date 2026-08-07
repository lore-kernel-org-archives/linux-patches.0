Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5365477994;
	Fri,  7 Aug 2026 15:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117001; cv=none; b=pzCfZ4rssvfsBr6C46mb6CFLMMCzmO1+ZI8wVWw1nESPAmiPlesiC/VSTfcyZ3UT5ypol5VOCdw4wbVZcv7C+xr304QevXQ+lvqXAM7XCjE9ewKZjgY/2z2tr8b5dB/pOohFK6qpmSZjJDOXEa2gOypUsC4TQDkd2NJWWGmC4HQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117001; c=relaxed/simple;
	bh=MUPx2kXmEtrafS+ZahyRDOLOstqXK5bn0B3oTt3ExU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n4GMcnj1vzYGYJXr6/EE1d5W5EKIuCWiGzeIcQ4CfUAs7Wja7b4csQEpF2X+N/H2BMcBVjsMiLvlhbzPEQ3DkN4AOHq5i1sqsIh3uSbu6tfK8pofETf2ue1IYOqarhizGaDQny6w/c90KOgniB19+Gl1g0wBYbceje6P6pKt5UE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YbgBjToQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YbgBjToQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52A2B1F000E9;
	Fri,  7 Aug 2026 15:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116999;
	bh=kQsymiIOiaIHbkH1ttTS9vcrqxNMtVHUvrVZJduir/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YbgBjToQaVMOOD+9R5YBRuXKEAFm5T1NeXaCqvXGCi82iZUtNR9w9zDnzGJzClDju
	 BtFI+Yd9syT7u53qYkHHiwm4KxnZ5APXKJCzKaHSCIWgdII23IRL1jvspnd5u756vA
	 aFtoKU2tQedWYNce5G7MqQ36oxIJfSvRfHs5Tc6Q=
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
Subject: [PATCH 7.1 120/438] netfs: release readahead folios on iterator preparation failure
Date: Fri,  7 Aug 2026 16:35:16 +0200
Message-ID: <20260807143430.551389512@linuxfoundation.org>
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

[ Upstream commit 87eb3d272dcbcbbfe5c1576c10e5dc72810cf1f6 ]

netfs_prepare_read_iterator() batches readahead folios in put_batch so that
the folio references can be dropped after the I/O iterator has been
prepared.

If rolling_buffer_load_from_ra() fails after earlier folios have been
batched, the function returns immediately and leaves those references held.
Release the batch before returning the error.

Fixes: 06fa229ceb36 ("netfs: Abstract out a rolling folio buffer implementation")
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260727130716.1099906-4-dhowells@redhat.com
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/buffered_read.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index 76d0f6a29abab..68534cef37cd2 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -102,8 +102,10 @@ static ssize_t netfs_prepare_read_iterator(struct netfs_io_subrequest *subreq,
 
 			added = rolling_buffer_load_from_ra(&rreq->buffer, ractl,
 							    &put_batch);
-			if (added < 0)
+			if (added < 0) {
+				folio_batch_release(&put_batch);
 				return added;
+			}
 			rreq->submitted += added;
 		}
 		folio_batch_release(&put_batch);
-- 
2.53.0



