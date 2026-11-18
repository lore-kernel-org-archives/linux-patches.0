Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060938;
	b=Twge95sttD9ZgZIn/0fguwBLnUCfBGYD+qKbw5ZP10wzzdh2uNrpSR/HSIu89odmYqfb
	 XeW8qYX3rb2dxoVtDgWfTO7P1/9KnPYpuIGLoynls0bC4xaZrPphgmncSMITybjQ9901M
	 RZQ+wX6V6FhHJKvrDmaHShzyMX/tX/3otsiwSva9FPHV28l4V6pT2ubYVy0dMS8JHpyMh
	 BLOVatGksUxIxYWuF4MmKzRzqUC8Nb6QrQxCGy9uvJ1kVHvXxHhFSGusWnTmdOtyGVTKI
	 Fd7xmca0vTa/zktSFc+8Gc8UXhdPpEJSCR11GPwb/kWc25oT172j6KEHgCsAV5wJhCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060938;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZttpAwWpqY5YjuuOZivf+tSPJqm1RiIYmAWxApRWe+E=;
	b=kP0mXh8BqinpU9E9cDqpwubWdsjPkRyt+Llf9YD9m6kWBZ9Gki5ztgWHGakQ0MgPoc8o
	 C8evwIV+g2kJb22I0GStsoUXyq4Js+icIbIoUYZSE63Rye6V9cAC89wlqC1uPqld9XOd8
	 CRRB8SyWC3HmL92NZUlO1fQJ870GOFFznVy2ujk+rETXvJXGo/X744qxtdP+w7L1RttJs
	 WiCyCHnr4G+NjWBKYdAXlT/uZhmefLIwi1EpVrC39PhEdjYByJ6upIajedIy5kQCDcT1O
	 /k+poVeGr4pK6Dm92iM1S1YJ7irFX25OEGEVArCa+56PC8TpYB1/X47jherPLH35XFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wbUzxDlg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB23C606A32C;
	Thu, 19 Nov 2026 04:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wbUzxDlg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA4FC1F000C4;
	Thu, 19 Nov 2026 04:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060938;
	bh=ZttpAwWpqY5YjuuOZivf+tSPJqm1RiIYmAWxApRWe+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wbUzxDlgkMaYVRC/eKYarVLy8xBoT4mSygAyGF6dSzjx/J14GvwOX7TlPEJqse0iJ
	 gmZEkjxXnu/oRoCKJ8welJbHprSCPfbgwgLJ8iiV4WNS4YFKzZYsPfapAwhP4o3DAS
	 xjqhm0OiaxkbqHyg76Q3yEjN3aMS1UdcHa4dyWPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1336/1848] kconfig: split randconfig setup code into set_randconfig_seed()
Date: Wed, 18 Nov 2026 15:56:14 +0100
Message-ID: <20261118150015.650564589@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 89145649b0d0d51e90a85de23ca881c97d3a71a4 ]

This code is too big to be placed in the switch statement.

Move the code into a new helper function. I slightly refactor the code
without changing the behavior.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Stable-dep-of: 9f01cd3a3243 ("kconfig: warn about malformed KCONFIG_PROBABILITY values")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/conf.c | 54 ++++++++++++++++++++++++------------------
 1 file changed, 31 insertions(+), 23 deletions(-)

diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index 0b1f2553cd939..05901b749fb3d 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -83,6 +83,36 @@ static void xfgets(char *str, int size, FILE *in)
 		printf("%s", str);
 }
 
+static void set_randconfig_seed(void)
+{
+	unsigned int seed;
+	char *env;
+	bool seed_set = false;
+
+	env = getenv("KCONFIG_SEED");
+	if (env && *env) {
+		char *endp;
+
+		seed = strtol(env, &endp, 0);
+		if (*endp == '\0')
+			seed_set = true;
+	}
+
+	if (!seed_set) {
+		struct timeval now;
+
+		/*
+		 * Use microseconds derived seed, compensate for systems where it may
+		 * be zero.
+		 */
+		gettimeofday(&now, NULL);
+		seed = (now.tv_sec + 1) * (now.tv_usec + 1);
+	}
+
+	printf("KCONFIG_SEED=0x%X\n", seed);
+	srand(seed);
+}
+
 static int conf_askvalue(struct symbol *sym, const char *def)
 {
 	enum symbol_type type = sym_get_type(sym);
@@ -541,30 +571,8 @@ int main(int ac, char **av)
 			defconfig_file = optarg;
 			break;
 		case randconfig:
-		{
-			struct timeval now;
-			unsigned int seed;
-			char *seed_env;
-
-			/*
-			 * Use microseconds derived seed,
-			 * compensate for systems where it may be zero
-			 */
-			gettimeofday(&now, NULL);
-			seed = (unsigned int)((now.tv_sec + 1) * (now.tv_usec + 1));
-
-			seed_env = getenv("KCONFIG_SEED");
-			if( seed_env && *seed_env ) {
-				char *endp;
-				int tmp = (int)strtol(seed_env, &endp, 0);
-				if (*endp == '\0') {
-					seed = tmp;
-				}
-			}
-			fprintf( stderr, "KCONFIG_SEED=0x%X\n", seed );
-			srand(seed);
+			set_randconfig_seed();
 			break;
-		}
 		case oldaskconfig:
 		case oldconfig:
 		case allnoconfig:
-- 
2.53.0



