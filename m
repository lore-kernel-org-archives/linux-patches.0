Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC66373BF2;
	Sat, 12 Sep 2026 10:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209793; cv=none; b=i62Eg6dMcrV4yd6prtnYezVUEEY4Y+54szO6LVwJEskTAgPBq6YID7P6vPfG8V6VtKem368eg4AjkoPdfVpsLsEnPMtBfzzUca6rue2d4aPCX/yEAmnMohjue9HnJDmlR0RFcNqlbMxXTt7KRDi1yi9oCmUeEsXz0UOuxUTCetA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209793; c=relaxed/simple;
	bh=DnqCX7+GFkDkneuTo+GkZauAuJnS9P3HnYSaiOBKsa4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KVTVg7fRDmiDq13WodOrqke1qZBjfq7R8k2jDofoBHWPZpW+yxCfqEw+zhLfIrnkOardAcNoagPfns5DoSHnLKJ/DsZJWNafpAuiD+JB8l6c4/P6eeO85eXkky+jRMje52/Lr8YqWM1S1bD2jnz1RN1wNN7Vy6wtQQHVUnF1AQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QNpDaHVa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QNpDaHVa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D571B1F000FF;
	Sat, 12 Sep 2026 10:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209789;
	bh=pV+5JPtwEpN37egCxypb5vfYeVi1NVmEUF0Q80Fcxpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QNpDaHVaVvzQEnevhHWyyu1eAvDe0WfuUcmbDVbSSzhAY3wD+PL1cav2lPqzjBJS5
	 M4Zku4yuLQ0x9IxJYyb4WGZxWlc+AwJKj2XzJ4Wp1TQECgKIUt0AaWCyPT2ur/1fmI
	 n6P/JKZ5KDTsoXOovlEzdSKKlVrWE1SzzDt4C8WM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robertus Diawan Chris <robertusdchris@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0893/1518] modpost: prevent leak when early return no suffix .o in read_symbols()
Date: Sat, 12 Sep 2026 08:51:02 +0200
Message-ID: <20260912065643.652187628@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robertus Diawan Chris <robertusdchris@gmail.com>

[ Upstream commit 9a5b76027ed91680e10f90111d9cba300f96d1ab ]

The allocation for elf info symsearch and hdr from parse_elf() haven't
been released when return because of modname didn't have suffix ".o".
And it seems like the suffix ".o" check did not depends on parse_elf()
to succeed first. So, move the suffix ".o" check before checking
parse_elf() result to prevent resource leak when the modname didn't have
suffix ".o" and return early.

This is reported by Coverity Scan as "Resource leak".

Fixes: 8c9ce89c5b63 ("modpost: simplify mod->name allocation")
Signed-off-by: Robertus Diawan Chris <robertusdchris@gmail.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Link: https://patch.msgid.link/20260624044742.144852-1-robertusdchris@gmail.com
Signed-off-by: Nicolas Schier <nsc@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/mod/modpost.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 010c398f6a705..31f81f25968fa 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1570,14 +1570,14 @@ static void read_symbols(const char *modname)
 	struct elf_info info = { };
 	Elf_Sym *sym;
 
-	if (!parse_elf(&info, modname))
-		return;
-
 	if (!strends(modname, ".o")) {
 		error("%s: filename must be suffixed with .o\n", modname);
 		return;
 	}
 
+	if (!parse_elf(&info, modname))
+		return;
+
 	/* strip trailing .o */
 	mod = new_module(modname, strlen(modname) - strlen(".o"));
 
-- 
2.53.0



