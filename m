Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1578A4FF78;
	Mon, 18 Dec 2023 14:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mLoXQret"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 516CCC433C7;
	Mon, 18 Dec 2023 14:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908377;
	bh=4qcJMFl3Yy7AUMFnBzhN7T3B/1nhDtMU5lmEfm8hpUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mLoXQrethFaovjEFiZ/RWkKtMInKZwBHFAwEz7+h13C5tFdAj0f1G7dOd6/P6i6yn
	 ynjtdVAavr+cZPcF0icl85rukIVSElTHxdFYvSD/ex/meLeXQvpLA/mZn+n6fF1Oww
	 lYEt9HArMKVSz9O1/zJnOsLQB1EuW1txwPCcTROk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 116/166] scripts/checkstack.pl: match all stack sizes for s390
Date: Mon, 18 Dec 2023 14:51:22 +0100
Message-ID: <20231218135110.227554906@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
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

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit aab1f809d7540def24498e81347740a7239a74d5 ]

For some unknown reason the regular expression for checkstack only matches
three digit numbers starting with the number "3", or any higher
number. Which means that it skips any stack sizes smaller than 304
bytes. This makes the checkstack script a bit less useful than it could be.

Change the script to match any number. To be filtered out stack sizes
can be configured with the min_stack variable, which omits any stack
frame sizes smaller than 100 bytes by default.

Tested-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/checkstack.pl | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/scripts/checkstack.pl b/scripts/checkstack.pl
index ac74f8629ceac..f27d552aec43f 100755
--- a/scripts/checkstack.pl
+++ b/scripts/checkstack.pl
@@ -97,8 +97,7 @@ my (@stack, $re, $dre, $sub, $x, $xs, $funcre, $min_stack);
 		#   11160:       a7 fb ff 60             aghi   %r15,-160
 		# or
 		#  100092:	 e3 f0 ff c8 ff 71	 lay	 %r15,-56(%r15)
-		$re = qr/.*(?:lay|ag?hi).*\%r15,-(([0-9]{2}|[3-9])[0-9]{2})
-		      (?:\(\%r15\))?$/ox;
+		$re = qr/.*(?:lay|ag?hi).*\%r15,-([0-9]+)(?:\(\%r15\))?$/o;
 	} elsif ($arch eq 'sparc' || $arch eq 'sparc64') {
 		# f0019d10:       9d e3 bf 90     save  %sp, -112, %sp
 		$re = qr/.*save.*%sp, -(([0-9]{2}|[3-9])[0-9]{2}), %sp/o;
-- 
2.43.0



