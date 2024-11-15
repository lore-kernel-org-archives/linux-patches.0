Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C13DEAD0;
	Fri, 15 Nov 2024 06:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653370; cv=none; b=h6fwhOVLOiIzWRHKeywPSCjC883gNrPNMFcCqfBcpoElXKffjC+xC2aBETIQrZUK17cNMnYs5HM4qwmuEqfEHLqwy13/xiVZrxPYOWtk4fWYQu7UQZaXfPiAEl0LpKnbQLL9dWfBB2jG0/FbLME8T+ABCVrOaNs1YtlQZ2J/PYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653370; c=relaxed/simple;
	bh=umvHoY1C6Y8snKBbIK/MBmTH726DtehJHg4pZTBnq84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XA9CQLWo5HFgXOQs4rVGmWFRqkGV8MI7PpmaRM0+1olvIPiY9fc4haW8Rw7zySj08ZnOmgt3Q3SlEXlISLIKF3Cm+nhrTLyKu30k65/ExsduK0j3ZAxsSfJ8SPIp7L1bFbRUlRMfY42YHwVRtDdZqMagNogiUkY68sPtZwXGgp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VcP4/8l8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VcP4/8l8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC2E8C4CECF;
	Fri, 15 Nov 2024 06:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653370;
	bh=umvHoY1C6Y8snKBbIK/MBmTH726DtehJHg4pZTBnq84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VcP4/8l8c4TGmfGGDuNhBMi919zTJUuwaaYpbrFL0tRXsTHoZkgcxfDBwUdZjMCRK
	 IgCjyPYX2fIJzAKzPjhfBtaunUgsAXLNsNJQBCrE2jECEb2ZxkbHTrd0tARtORMwQR
	 ARBR5SiMXuto6qc2qEk8b8eKUI9Y54yN1T9UCLiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Buffet <matthieu@buffet.re>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 33/63] samples/landlock: Fix port parsing in sandboxer
Date: Fri, 15 Nov 2024 07:37:56 +0100
Message-ID: <20241115063727.114214633@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.892410236@linuxfoundation.org>
References: <20241115063725.892410236@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Buffet <matthieu@buffet.re>

[ Upstream commit 387285530d1d4bdba8c5dff5aeabd8d71638173f ]

If you want to specify that no port can be bind()ed, you would think
(looking quickly at both help message and code) that setting
LL_TCP_BIND="" would do it.

However the code splits on ":" then applies atoi(), which does not allow
checking for errors. Passing an empty string returns 0, which is
interpreted as "allow bind(0)", which means bind to any ephemeral port.
This bug occurs whenever passing an empty string or when leaving a
trailing/leading colon, making it impossible to completely deny bind().

To reproduce:
export LL_FS_RO="/" LL_FS_RW="" LL_TCP_BIND=""
./sandboxer strace -e bind nc -n -vvv -l -p 0
Executing the sandboxed command...
bind(3, {sa_family=AF_INET, sin_port=htons(0),
     sin_addr=inet_addr("0.0.0.0")}, 16) = 0
Listening on 0.0.0.0 37629

Use strtoull(3) instead, which allows error checking. Check that the
entire string has been parsed correctly without overflows/underflows,
but not that the __u64 (the type of struct landlock_net_port_attr.port)
is a valid __u16 port: that is already done by the kernel.

Fixes: 5e990dcef12e ("samples/landlock: Support TCP restrictions")
Signed-off-by: Matthieu Buffet <matthieu@buffet.re>
Link: https://lore.kernel.org/r/20241019151534.1400605-2-matthieu@buffet.re
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/landlock/sandboxer.c | 32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/samples/landlock/sandboxer.c b/samples/landlock/sandboxer.c
index e8223c3e781ab..5d8a9df5273f5 100644
--- a/samples/landlock/sandboxer.c
+++ b/samples/landlock/sandboxer.c
@@ -57,6 +57,25 @@ static inline int landlock_restrict_self(const int ruleset_fd,
 #define ENV_TCP_CONNECT_NAME "LL_TCP_CONNECT"
 #define ENV_DELIMITER ":"
 
+static int str2num(const char *numstr, __u64 *num_dst)
+{
+	char *endptr = NULL;
+	int err = 0;
+	__u64 num;
+
+	errno = 0;
+	num = strtoull(numstr, &endptr, 10);
+	if (errno != 0)
+		err = errno;
+	/* Was the string empty, or not entirely parsed successfully? */
+	else if ((*numstr == '\0') || (*endptr != '\0'))
+		err = EINVAL;
+	else
+		*num_dst = num;
+
+	return err;
+}
+
 static int parse_path(char *env_path, const char ***const path_list)
 {
 	int i, num_paths = 0;
@@ -157,7 +176,6 @@ static int populate_ruleset_net(const char *const env_var, const int ruleset_fd,
 	char *env_port_name, *env_port_name_next, *strport;
 	struct landlock_net_port_attr net_port = {
 		.allowed_access = allowed_access,
-		.port = 0,
 	};
 
 	env_port_name = getenv(env_var);
@@ -168,7 +186,17 @@ static int populate_ruleset_net(const char *const env_var, const int ruleset_fd,
 
 	env_port_name_next = env_port_name;
 	while ((strport = strsep(&env_port_name_next, ENV_DELIMITER))) {
-		net_port.port = atoi(strport);
+		__u64 port;
+
+		if (strcmp(strport, "") == 0)
+			continue;
+
+		if (str2num(strport, &port)) {
+			fprintf(stderr, "Failed to parse port at \"%s\"\n",
+				strport);
+			goto out_free_name;
+		}
+		net_port.port = port;
 		if (landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
 				      &net_port, 0)) {
 			fprintf(stderr,
-- 
2.43.0



