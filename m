Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6286FE0B;
	Mon, 29 Jan 2024 17:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548482; cv=none; b=mXAwqw5CQdwlvSqdO5Ve5T7cdC8FIBcsVr4YXqu+sBciX/CfiIh2k3Xy0G7VF1ReF8fSX8LNWFKFCst43B2AWazqcqiU+9vvYnRnFGpEG4qbSJjyGYcEtYAL1weUac4mKuzJTlhy8WSqFv/yPmU3p4WAl8vshj6ibONT0Z9B1aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548482; c=relaxed/simple;
	bh=7/zTl4Dh0Hg3DvFu3e/3xrDv6eiv4I4kpPiDIBouxRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jiNTzp5YmhrsINinffBfDGExG/zsBYo/WxpwZAtx3nkU3Pv63sdhE5xHR/spdkznDo1X3Y6WUg5yp1PSFhE77pf/+cBZIjcLqDsrKJ84RjKccLzL7SSWjH8YAeuKS1N9o8ocrBatqppXg0UW0jXmnBCePfeSX7yFjEZXi/OdsVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jZJFv//o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jZJFv//o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 588D8C43394;
	Mon, 29 Jan 2024 17:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548482;
	bh=7/zTl4Dh0Hg3DvFu3e/3xrDv6eiv4I4kpPiDIBouxRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jZJFv//o1AeKYXmGRgnf/IU1bX6NYWE21R71dDn1UUMsYpS/JRUfz6CcFTE1nEiO2
	 dokO5dLlkMWJewZIaM6/7fHNFWnWIKzP+lkkm36LaAVqdavDIFyd5Lm0kzDs7CSuxy
	 d1macy0H3QHnJumJZzOsmBK7ziGYIhMEyMXfYjeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jani Nikula <jani.nikula@intel.com>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 6.6 102/331] scripts/get_abi: fix source path leak
Date: Mon, 29 Jan 2024 09:02:46 -0800
Message-ID: <20240129170017.916513094@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


