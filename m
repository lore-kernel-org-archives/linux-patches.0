Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF25E27713;
	Tue,  9 Jul 2024 11:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524305; cv=none; b=Hz1eV+Pm1eQ4EK18LHR0GeoJdZjCplrlWrnSHJmZZ59jQyJD2SW3Dr4sq1Ko9ptXYzWj0EgzoKNvrtA4sSTUvpYejr0bBheeLrdf/9jOjMSBXwnEcA6kLUAi2PlvF3Whe3LAqBIZQgYAmacjRpywYO4ityTSWQUEsocIdw91mZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524305; c=relaxed/simple;
	bh=u5t/KnAiumdQDTeLxXHoydiBZnO9a+J4qspZwi+igOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WKfRYjX7kMUqPKHjod5gX5yyHD4C+iy7DFCfklwW9jMX6PGiEYYTvqb4/Uqt4UAohAaWOXMuM7cpufFNnwDlvDXei3Gm5FgwHbpFvX3aBc6IoqRnC6teZoHt3r+kaND8BUVoz2evfNGvNPFuh0TJudSceAr0OUvYTGfPp6Pm0vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cUBJ3wMz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cUBJ3wMz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74551C3277B;
	Tue,  9 Jul 2024 11:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524304;
	bh=u5t/KnAiumdQDTeLxXHoydiBZnO9a+J4qspZwi+igOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cUBJ3wMzl/77LkzHqrSgSHCsaT1H+lPXVyp6V7xcdisTIepEdDPj/7AzPLmxG/5Zl
	 OAQQUoxIgHJdJvq3xfjaJPM4D+12Qr/asCXPOtbWZ9UCeNLFjlzOjb3i9GFCX7W+i3
	 nGS5K8J8SR3M1HPnIOAIF02jNY2dTez/1UwMt5bU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ed Tomlinson <edtoml@gmail.com>,
	Filipe Manana <fdmanana@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.9 140/197] btrfs: fix folio refcount in __alloc_dummy_extent_buffer()
Date: Tue,  9 Jul 2024 13:09:54 +0200
Message-ID: <20240709110714.370128223@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Burkov <boris@bur.io>

commit a56c85fa2d59ab0780514741550edf87989a66e9 upstream.

Another improper use of __folio_put() in an error path after freshly
allocating pages/folios which returns them with the refcount initialized
to 1. The refactor from __free_pages() -> __folio_put() (instead of
folio_put) removed a refcount decrement found in __free_pages() and
folio_put but absent from __folio_put().

Fixes: 13df3775efca ("btrfs: cleanup metadata page pointer usage")
CC: stable@vger.kernel.org # 6.8+
Tested-by: Ed Tomlinson <edtoml@gmail.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Boris Burkov <boris@bur.io>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent_io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3526,7 +3526,7 @@ err:
 	for (int i = 0; i < num_folios; i++) {
 		if (eb->folios[i]) {
 			detach_extent_buffer_folio(eb, eb->folios[i]);
-			__folio_put(eb->folios[i]);
+			folio_put(eb->folios[i]);
 		}
 	}
 	__free_extent_buffer(eb);


