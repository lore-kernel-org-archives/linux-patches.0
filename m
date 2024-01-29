Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79DB61586CF;
	Mon, 29 Jan 2024 17:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548244; cv=none; b=EVTJQsqJFAsHNHzQOjzvuE2sOTv85WwfEUHyRqe4KxQITs0e/xW2LnSzf4nQDtdmQsEg3hKTA6ycIxlupX6eh/n/fC68lA5OSw0v1lQCqZaDym4Ug4stG3cSWb8+FT4gxTjGlDEQ7cu1VhMP8+Qp4/nLaxgarW3/oJJmzgws/5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548244; c=relaxed/simple;
	bh=3oV0z0oT38cjQMXrhAmnkuMo5dlOCSTLWwkweuXDbRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U0MUZ9tpyLwhIIfGhiWcVjLxcUlCoYQvfcXWXKS0L37+3zfLph4SzFNhqFe+cW291Ol6hJFSkvozcQN0Cy2dHssYpf7bxLlXRbnOyQRYGb5BnYsAxToJxQtmTni8yNIDF8Kh040EWy0RA98mWzrglaA1YDSa8+4pU7OTEuSTY6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H8yCckd9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H8yCckd9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C4E4C43394;
	Mon, 29 Jan 2024 17:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548244;
	bh=3oV0z0oT38cjQMXrhAmnkuMo5dlOCSTLWwkweuXDbRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H8yCckd9TScvArvVPy71joJaBbY1SFK8tnSRw1q6Fy3yKpRmPh5rLk28fGSJwtLRz
	 hroRg0hKo/25uJZi2Z36Ft8OzP+TIV0jrnkm2VHC7K3e5xydzjWBTv5zrGdJm82Tew
	 ivixclMjbFlda2Mus4T40Q3Muj9e2CLGnnT0KX3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jani Nikula <jani.nikula@intel.com>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 6.1 042/185] scripts/get_abi: fix source path leak
Date: Mon, 29 Jan 2024 09:04:02 -0800
Message-ID: <20240129165959.935363057@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


