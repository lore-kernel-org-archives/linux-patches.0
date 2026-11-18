Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021748;
	b=MtUPSdP4P9+KDW6sEs+5y21VsTFITqaxr1XEabC+2qfLTVHqDE98R8iNNs9MHRzCPWhZ
	 wPH5AmO6qbjcyTVUvROp+8o8wTTyQqs7FNCqYw88SKa8SRo672Gfz22SMU0SMpGPfPUZS
	 53Zeod5vIke82ZC7DReZ92IPKi0AM3Mofalf8BSwRymGL0MW4nZoM/O3ELNyT9YoBdYNT
	 b6EwKOuSsPXoodD4Am4Vt7K3TvWB5KUk69kqWmPnmH/H7HYct6OO2/k71Ih2EPKmf6E0i
	 JwX/TqIZSTp614bUd92V2+qf4e3ldIz0eGQuJOek1cn/3LA/sUfCrE5Ek9egoOIHIdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021748;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BcZgrPXaFl4TIdtj0bm8iC7U7zQFWVXrlIg5OwcLfZU=;
	b=hXnN7bAa7uw6JL0PD96u2e65H1kf5HebNcVYrxiz4f7RcW6l3WD4cnQBr8YYhAaVHc5r
	 67n3purPg4S1qHhkYDJ04YxSI4eZROaa/gccT4o9yK2E33NunoarmGzXptEBerYs7QYED
	 2zQp45E20iCwiTr0W21xsweIL3PrQ3pNUmtIbFyCS3/YVqgLWWFVYw9agBKOMG+rckRe2
	 2v1ul2q6Th9EUSCgUFk1gPCl2xw10Y1Ykcm52RGUVaY9SGSuzA3ZOaAT6DK9RXwcxQtpi
	 YW2pdCUthGuLXBZau61w+ps0/epfAuJaVBWl+/Ze2z7cIiowJFWaY7Caa27je4vcOzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A7NCJ49i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D34F606A32F;
	Wed, 18 Nov 2026 17:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A7NCJ49i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCD6F1F000C5;
	Wed, 18 Nov 2026 17:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021748;
	bh=BcZgrPXaFl4TIdtj0bm8iC7U7zQFWVXrlIg5OwcLfZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A7NCJ49iUu9QqtCHnxAR86Q6UNcAD2DOyQOj3yizqyYhMUbvRw/zIpWpiZzA/UVlV
	 TNVNgofxt4mF/t8qxFTUdrzbqGHIwDkHL5E+j/gAARPHBgbys8nRHfG4Pc76v4NBhS
	 MtkewByuF5L5OTgSzp8EKSfRIUiN9cOhsiupvZTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tal Zussman <tz2294@columbia.edu>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2418/2651] ceph: dont clear write_congested when collecting folios
Date: Wed, 18 Nov 2026 16:00:58 +0100
Message-ID: <20261118150412.316483935@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Tal Zussman <tz2294@columbia.edu>

[ Upstream commit 77ff2ba4630b9e9e9f73bbaaeb675638b2c20dd0 ]

ceph_process_folio_batch() assigns the result of
is_write_congestion_happened() to fsc->write_congested for every folio
it collects. The code it replaced only ever set write_congested to true
here, leaving the decrement paths to clear it once writeback_count
drops below CONGESTION_OFF_THRESH. The unconditional assignment means
that a sync writeback that runs while the count sits between the off and
on thresholds clears the flag on its first folio, and background
writeback resumes early.

Only set the flag here, as before.

Fixes: ce80b76dd327 ("ceph: introduce ceph_process_folio_batch() method")
Assisted-by: Claude:fable-5.1
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/addr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 60cf6a81af35a..edf3ad5a0bfc8 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1429,7 +1429,8 @@ void ceph_process_folio_batch(struct address_space *mapping,
 			break;
 		}
 
-		fsc->write_congested = is_write_congestion_happened(fsc);
+		if (is_write_congestion_happened(fsc))
+			fsc->write_congested = true;
 
 		ceph_wbc->fbatch.folios[i] = NULL;
 		ceph_wbc->len += folio_size(folio);
-- 
2.53.0



