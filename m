Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C889157041;
	Mon, 29 Jan 2024 17:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548082; cv=none; b=QV/9LkfgHGTH6+FWd2CMUcBbxmegi5Jn4yf3HAxaHUsQ+BEBpN1qKrRqET+x6wNSXdISyenZLLqUurxaGS3NwgC2FAiDnJeMmAWGyrkrVaD/gVf/Ma62llmt1BCv34PYwrlE+iekt/Sran6cWcrFVXBKF3UZdLhDaV49exvlBBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548082; c=relaxed/simple;
	bh=Q1tFeJ/fbEc1ub2Ti+C5j4DzM7RU7st/1M4I8mulXJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fDMPodhaKDHbAsiHoxqVCDbF8d7qu4GS4Rh/uRmljfuyT0u1/4uZNw2xpRF27fdbWJg7+i8Z1hqqIWtE3MIzfXp4fhXrLDN+ULnEUDyaZaYKGqsSLFxcAOxfGvcXlqMdsmRyb+pxyiDJX2890Wg24WEJGWYKdg3eqdrQiR8Va8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mF58rF/e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mF58rF/e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 249A8C43390;
	Mon, 29 Jan 2024 17:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548082;
	bh=Q1tFeJ/fbEc1ub2Ti+C5j4DzM7RU7st/1M4I8mulXJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mF58rF/e0xe/DmxI07WcRiMEnlH7zFLBA55dD+NqpjPC8zBnIu5E+9LYyb07qEBhI
	 m6M4BSv7sRj83vji1pzytR4dY1kP1H+j/52tL1m9UYgWcbrEYBttoip19k9WVO23X5
	 aw+9Vxl53MRJKG69Tmgog2i7tDDRDRQmbGWxOXvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jani Nikula <jani.nikula@intel.com>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 6.7 095/346] scripts/get_abi: fix source path leak
Date: Mon, 29 Jan 2024 09:02:06 -0800
Message-ID: <20240129170019.201489959@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vegard Nossum <vegard.nossum@oracle.com>

commit 5889d6ede53bc17252f79c142387e007224aa554 upstream.

The code currently leaks the absolute path of the ABI files into the
rendered documentation.

There exists code to prevent this, but it is not effective when an
absolute path is passed, which it is when $srctree is used.

I consider this to be a minimal, stop-gap fix; a better fix would strip
off the actual prefix instead of hacking it off with a regex.

Link: https://mastodon.social/@vegard/111677490643495163
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Link: https://lore.kernel.org/r/20231231235959.3342928-1-vegard.nossum@oracle.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/get_abi.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/get_abi.pl
+++ b/scripts/get_abi.pl
@@ -98,7 +98,7 @@ sub parse_abi {
 	$name =~ s,.*/,,;
 
 	my $fn = $file;
-	$fn =~ s,Documentation/ABI/,,;
+	$fn =~ s,.*Documentation/ABI/,,;
 
 	my $nametag = "File $fn";
 	$data{$nametag}->{what} = "File $name";


