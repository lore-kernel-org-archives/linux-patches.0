Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623478;
	b=r+ikUXRiiHKMGSv2SjAxgBP1Zo7RS88ktFmlprop0yqrGPqiaJmGRYcPuqO5/nVd9oiZ
	 iouLkYhrXDdoBcS59oQZOe+wUFgtCGNyApxguTGYzvbmgHZdOLsmeAJDlaqxB87WVWDEs
	 SyepFy8wj/f4+g63OREIsHyZjAKPAaInf7LHnIN/0VQ7o+LWLW08WvdBC1znh3k2hlkU0
	 Rg6ou1rsZwG8EnqE8ox9cHaJceHrl/QC9EkxzKCXHPtbfJmH1CSyzRbaa4D+eab9OY8cQ
	 kL1eSqm7IL3SZv9XdmhfNdbKDONT+8omxXN4CuQ3f34X4SMq0nUQ7oCmpQc317k6fNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623478;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DkZAAR0e86n43dNRi1/yOrw9khXd/8BrXSsOizAcsyo=;
	b=XCAgZwsxStXEm2tH85VUeyvLrbciPptBxM3G4taKHHHQXZSK7U+TVHDBn0Df2WcIN/JQ
	 kNE3HlFgDhekk1mGnjCweyVn52SgEQm9l26pQNbV0mslSyCvoVKXk5NcxRuV87z3y5P5w
	 pPIx0oXGixczyUUwXLa8HSrnMAG/IqI8Y1Xq/9RY51vSnbRkYTVcKUxbZFyEheJK6TbKb
	 nbq3hyskAB6U6PVe6il9IhVyzFIWUg8Iw2wDDvNvFeGgsydCONI6dSiL3iG4T+bTkI5U9
	 u9gA7QvlbDnIj68mn17AHS11cnkgP9BazUAA02MxbGYmDm7kbspTFNN49i7O7l9xIxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nro0FItK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C632B606A321;
	Wed, 25 Nov 2026 16:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nro0FItK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A22A61F000C6;
	Wed, 25 Nov 2026 16:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623478;
	bh=DkZAAR0e86n43dNRi1/yOrw9khXd/8BrXSsOizAcsyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nro0FItKJvsVeki8kCtcApoFKxu+ccNBZznz0hz28EKV29GM08qNRD0/AodcWMQuQ
	 ta/ZuPdjrZQCt4ewAVDrkFC8OWPIKVlHGP+xDm5YQUvLCZUjxVYOlexN/ogjEJF6mU
	 27HmLXvBdUySsw7mCXrMmRUBbXMnEga0FQ+CpGdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.18 871/990] dm-cache: fix ending a cursor that never began
Date: Wed, 25 Nov 2026 15:37:18 +0100
Message-ID: <20261125143842.423561501@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 421420758be348cb90715bfaa26e1211a12ff1d0 upstream.

If dm_bitset_cursor_begin fails, dm_array_cursor_end(&cmd->hint_cursor)
is called. However, cmd->hint_cursor was only initialized if the variable
hints_valid is true. Thus, we must also destroy hint_cursor only if
hints_valid is true.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-5
Cc: stable@vger.kernel.org
Fixes: 629d0a8a1a10 ("dm cache metadata: add "metadata2" feature")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-cache-metadata.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-cache-metadata.c
+++ b/drivers/md/dm-cache-metadata.c
@@ -1433,7 +1433,8 @@ static int __load_mappings(struct dm_cac
 					   from_cblock(cmd->cache_blocks),
 					   &cmd->dirty_cursor);
 		if (r) {
-			dm_array_cursor_end(&cmd->hint_cursor);
+			if (hints_valid)
+				dm_array_cursor_end(&cmd->hint_cursor);
 			dm_array_cursor_end(&cmd->mapping_cursor);
 			return r;
 		}


