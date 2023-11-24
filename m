Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B66364A6;
	Fri, 24 Nov 2023 18:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UGZcfij1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95397C433C7;
	Fri, 24 Nov 2023 18:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852053;
	bh=fZ9i4iL3NuZaWD7S435jyMV6C5XYAdcRnEpnUaT0+C8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UGZcfij1EvxHnOBf538aioJkC82eSaGB3QGBm+i4LbviLQu+hQ/lhPbZxrbzvL1aN
	 IRlNfWPG3g5ONQZSLYcxS87orUd/ikSPHWo5vnHO4cmEOtoBugO3xex7jr00YZZYXp
	 esi9SgHn1/4Jh37ezsNUxYYy3JJvrDpuouWvey78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.1 202/372] KEYS: trusted: Rollback init_trusted() consistently
Date: Fri, 24 Nov 2023 17:49:49 +0000
Message-ID: <20231124172017.192104672@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
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

From: Jarkko Sakkinen <jarkko@kernel.org>

commit 31de287345f41bbfaec36a5c8cbdba035cf76442 upstream.

Do bind neither static calls nor trusted_key_exit() before a successful
init, in order to maintain a consistent state. In addition, depart the
init_trusted() in the case of a real error (i.e. getting back something
else than -ENODEV).

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Closes: https://lore.kernel.org/linux-integrity/CAHk-=whOPoLaWM8S8GgoOPT7a2+nMH5h3TLKtn=R_3w4R1_Uvg@mail.gmail.com/
Cc: stable@vger.kernel.org # v5.13+
Fixes: 5d0682be3189 ("KEYS: trusted: Add generic trusted keys framework")
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/keys/trusted-keys/trusted_core.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/security/keys/trusted-keys/trusted_core.c
+++ b/security/keys/trusted-keys/trusted_core.c
@@ -358,17 +358,17 @@ static int __init init_trusted(void)
 		if (!get_random)
 			get_random = kernel_get_random;
 
-		static_call_update(trusted_key_seal,
-				   trusted_key_sources[i].ops->seal);
-		static_call_update(trusted_key_unseal,
-				   trusted_key_sources[i].ops->unseal);
-		static_call_update(trusted_key_get_random,
-				   get_random);
-		trusted_key_exit = trusted_key_sources[i].ops->exit;
-		migratable = trusted_key_sources[i].ops->migratable;
-
 		ret = trusted_key_sources[i].ops->init();
-		if (!ret)
+		if (!ret) {
+			static_call_update(trusted_key_seal, trusted_key_sources[i].ops->seal);
+			static_call_update(trusted_key_unseal, trusted_key_sources[i].ops->unseal);
+			static_call_update(trusted_key_get_random, get_random);
+
+			trusted_key_exit = trusted_key_sources[i].ops->exit;
+			migratable = trusted_key_sources[i].ops->migratable;
+		}
+
+		if (!ret || ret != -ENODEV)
 			break;
 	}
 


