Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034031;
	b=11c266JX16GPQUqvPQT0dYmKJT4Jl6vX0ii+P0VHyZsfsWQZajwDruni/5XKcpPY+kBj
	 4U+gPasZdtDNrMyTQ3IiDz9lAc2sBneHQJyjBgtPAC3MxOuqZPpF9nLWeqsD9e3xz200K
	 3WMoS3jiczmQueFWey+zf8yg8+PAtMmoZM1zOje54f2HwvoEwNC6cvB+1UdDrCnAV/zdr
	 X64dDxP8XXOhA9vek7luxwar6RN65zVi4g54QaWN0b+ORl6SSmDxLCdHFaHBikPtC3Hj9
	 ugQrSur3txNbXQ160WONvG/8MSaBaNnQgvEoI3cl8cZkf/pBNI9/2/UFPiml5Xo+1lQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034031;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x0pqEdFSr/8n7hNsyaopTvkUu29bhqE4QQDyA1cXtkg=;
	b=nkLwD1THOvbccj9ARQAfeHJlE21LX51why8cRL/7eVReTU464HyaEFNttIGnn0cbZb6v
	 Y+J8zn0mfOkgvhLYzkVB38JeLl5x8aY786xJbZaTEUTiOgnpLWH3W6cInIm7Dk3hLbSRK
	 kju8Sdqu5GprG56XB2dO24hSzqxqLC7jsw8vR7NUZ7OUo7joSh8wGpDJq8KnNPZwg7xrg
	 43iEpBpJih1b6tpOfukAcfMgaiYyQlN3PLKnitmNMupjdGmeenx7C9IHgnvroo4t9DHCb
	 3kfO27o9Ktp4gM/eRUu+yPqF5vn6sOZev8Hw+hEAcGCsF7g+M8W1EZwCh31UIPkipKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="UWtmT/Cl";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D385F606A331;
	Wed, 18 Nov 2026 20:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UWtmT/Cl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31A361F000C8;
	Wed, 18 Nov 2026 20:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034031;
	bh=x0pqEdFSr/8n7hNsyaopTvkUu29bhqE4QQDyA1cXtkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UWtmT/ClqwEhaYlYu07knReu+er8/vejKVWjlzqgVeFriEDfsWxqYtGm6WbDyfRk9
	 aYDLjkqFqo3sMKSjOY1durVo1hzCk60YdAdbcPe/scfzhs3K52ELrhY9Xa0T79mrJ8
	 eZDhaT3veE5T0gM4uuUQ45DxReOYupKyywO4YUs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Glass <sjg@chromium.org>,
	Nicolas Schier <nsc@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0225/3318] kconfig: abort rather than loop for ever on EOF
Date: Wed, 18 Nov 2026 15:14:07 +0100
Message-ID: <20261118150321.765479411@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Glass <sjg@chromium.org>

[ Upstream commit f915149f5cfbd0d4406ec0b0f57b1d2c8685ae55 ]

When a non-interactive 'make oldconfig' or 'syncconfig' meets a new int
or hex symbol whose default cannot be applied, conf_string() reads a
value from stdin. At end of file fgets() returns NULL, no value is set
and the loop asks again. The result is an endless loop which fills the
output until it exhausts memory, rather than a clean failure.

Detect this in conf_string(): if the value cannot be set and stdin is at
end of file, stop with an error that names the symbol.

Note that a symbol with no default doesn't trigger this, since
sym_calc_value() falls back to 0, which is accepted at end of file. The
loop is triggered by a broken Kconfig file, with a default whose text
fails sym_string_valid().

Such mistakes do creep in from time to time and are hard to debug, since
the build fills the log with repeated prompts instead of pointing at the
offending symbol. Some bad defaults draw a parse-time warning, but
menu_validate_number() accepts a reference to any int or hex symbol, so
a cross-type reference loops with no warning at all. For example, "0xff"
is not a valid int value:

  config HEXSYM
          hex
          default 0xff

  config VAL
          int "Value"
          default HEXSYM

Interactive use is unaffected, since feof() only becomes true once a
read actually hits end of file: an invalid answer at a terminal still
re-prompts, while Ctrl-D at such a prompt exits with the error instead
of looping. bool and tristate symbols and choices already accept the
default on an empty line, so they still take their defaults in a
non-interactive build.

Tested with int and hex symbols carrying such defaults: with empty
stdin, the code without this change produces around 190MB of repeated
prompts within two seconds, while with the change it exits 1 naming the
symbol. Piped and interactive (pty) sessions still re-prompt on an
invalid answer and then accept a valid one. A new string symbol with no
default still takes the empty string at end of file, since any text is
valid for a string.

Signed-off-by: Simon Glass <sjg@chromium.org>
Link: https://patch.msgid.link/20260714133545.3294648-1-sjg@chromium.org
Signed-off-by: Nicolas Schier <nsc@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/conf.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index 6c4ff012a05eb..fde46ed7eb397 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -374,6 +374,23 @@ static int conf_string(struct menu *menu)
 		}
 		if (def && sym_set_string_value(sym, def))
 			return 0;
+
+		/*
+		 * A new int or hex symbol whose default fails validation
+		 * cannot be set from an empty answer. When standard input is
+		 * exhausted, as it is for a non-interactive oldconfig or
+		 * syncconfig, re-asking would loop forever and grow the output
+		 * until it exhausts memory. Stop with an error that names the
+		 * symbol instead. String symbols accept any text, and bool and
+		 * tristate symbols (conf_sym()) and choices (conf_choice())
+		 * accept the default on an empty line, so they are unaffected.
+		 */
+		if (feof(stdin)) {
+			fprintf(stderr,
+				"\nerror: no value for new symbol '%s' at end of input\n",
+				sym->name);
+			exit(1);
+		}
 	}
 }
 
-- 
2.53.0



