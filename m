Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E3612B70;
	Sat,  3 Feb 2024 04:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933433; cv=none; b=TAJN1/BTb3EWYCeG4a/rfNDerYqj6iTWUmyNxzIxFjF/kAtlii0QLmGh0J5ZO8xvlt6m/Q4Zu8S1fRvrsCdaGpBtGazuo1NGYYV1e/8RU72I6ssKPCDT8N1x25uq8jG9nc7MaT9TMbXz6rvLd8SM6HANAiSDApYr5JMFwZPo638=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933433; c=relaxed/simple;
	bh=OR1qHp2U6anIbWIUerdirow6LidLbeVC+cO76WQFuQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FovchdPBXNt0XcIG75QtdquZm8iCRq+9w5XEdOe0LpwHCXvP5E4IVFv7glI3/AVEQy1EYcqxYvCzyd3c+9LYZqVXvVHtIwM2wBnpF7a6Tv1Waae+LdhvLTgjUj54S9pbUfp/V32hD5RQzoxBV0VF9Vr6llCXY4/c7r3Crvvq/R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=olYKJ8JJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="olYKJ8JJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48EB0C433C7;
	Sat,  3 Feb 2024 04:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933433;
	bh=OR1qHp2U6anIbWIUerdirow6LidLbeVC+cO76WQFuQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=olYKJ8JJ0Zqzg0JDmOMEo/2MkPi1RNn//kLOHLxt9E4UAGOmsBjtv1WWNbsMP8SYr
	 bO6KWAKYZeqRHILrOSgEeVJyqptr7hgCc+8gXEqe3kHhs0DwWCP2m7vaBM4Vf/rCkb
	 UO5dXS+PnbAaiQnX/4nQh1XtmMIVy6IfKdrMMOXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jo Van Bulck <jo.vanbulck@cs.kuleuven.be>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 162/219] selftests/sgx: Fix linker script asserts
Date: Fri,  2 Feb 2024 20:05:35 -0800
Message-ID: <20240203035339.324548186@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

From: Jo Van Bulck <jo.vanbulck@cs.kuleuven.be>

[ Upstream commit 9fd552ee32c6c1e27c125016b87d295bea6faea7 ]

DEFINED only considers symbols, not section names. Hence, replace the
check for .got.plt with the _GLOBAL_OFFSET_TABLE_ symbol and remove other
(non-essential) asserts.

Signed-off-by: Jo Van Bulck <jo.vanbulck@cs.kuleuven.be>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Link: https://lore.kernel.org/all/20231005153854.25566-10-jo.vanbulck%40cs.kuleuven.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/sgx/test_encl.lds | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/tools/testing/selftests/sgx/test_encl.lds b/tools/testing/selftests/sgx/test_encl.lds
index a1ec64f7d91f..108bc11d1d8c 100644
--- a/tools/testing/selftests/sgx/test_encl.lds
+++ b/tools/testing/selftests/sgx/test_encl.lds
@@ -34,8 +34,4 @@ SECTIONS
 	}
 }
 
-ASSERT(!DEFINED(.altinstructions), "ALTERNATIVES are not supported in enclaves")
-ASSERT(!DEFINED(.altinstr_replacement), "ALTERNATIVES are not supported in enclaves")
-ASSERT(!DEFINED(.discard.retpoline_safe), "RETPOLINE ALTERNATIVES are not supported in enclaves")
-ASSERT(!DEFINED(.discard.nospec), "RETPOLINE ALTERNATIVES are not supported in enclaves")
-ASSERT(!DEFINED(.got.plt), "Libcalls are not supported in enclaves")
+ASSERT(!DEFINED(_GLOBAL_OFFSET_TABLE_), "Libcalls through GOT are not supported in enclaves")
-- 
2.43.0



