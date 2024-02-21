Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5309B7BB0F;
	Wed, 21 Feb 2024 13:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521921; cv=none; b=X86L0U9U+qIyZbChGr44NHeaWQYcS/kxBmxqKetr8XAK5pUW3nsG02m1yXU/PZ4/rN+ZCdhU0DDUfBy+41n6gugXoQRC52/c7EryWCr29uR9rOdceQ+K5KMjBRx/CMpT5/3EH8zc/SWcOa5u6ZRWoVyjXd+AnVIDJZMOpeYCbqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521921; c=relaxed/simple;
	bh=PQ3Kq2M7CYt4lQb78rL6nyxcvtxSzKDYVTX8YWH9K9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XXcqps3MwExw80xj2G227jiM9HAF3fUP9xDbpANskHwzcoFDwm4l6PJFE28OSaX+THPCJ0pW7gGamvi7vwe63IfmYaGg3jpSrAKcOXC6Yy6rzCDqFatWav1XyJ66vfOiyXaEV7CVVh7W1+zpYzJQ3qIxd1F44V5wemNkRvcWdjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fIHmC/Jp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fIHmC/Jp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3F53C433F1;
	Wed, 21 Feb 2024 13:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521921;
	bh=PQ3Kq2M7CYt4lQb78rL6nyxcvtxSzKDYVTX8YWH9K9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fIHmC/JpfHYJzViDbi4S4mdeKrahbdVGP5VxYkn9W4jKKxCS3/kI+0nZjV+s66lPA
	 qsskXSZHYOqDazaqbXRKnTeLQ0IbQf2J5lsF+3RfUB8/bQqZPBqhsYluLWNZxlnxHN
	 Xj+OCtNFCgW6G+f4n7LGd9pv71LDGeo6vESejXMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jani Nikula <jani.nikula@intel.com>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 5.15 033/476] scripts/get_abi: fix source path leak
Date: Wed, 21 Feb 2024 14:01:24 +0100
Message-ID: <20240221130009.168888879@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -75,7 +75,7 @@ sub parse_abi {
 	$name =~ s,.*/,,;
 
 	my $fn = $file;
-	$fn =~ s,Documentation/ABI/,,;
+	$fn =~ s,.*Documentation/ABI/,,;
 
 	my $nametag = "File $fn";
 	$data{$nametag}->{what} = "File $name";


