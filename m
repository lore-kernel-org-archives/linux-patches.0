Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2672C327E;
	Mon,  2 Jun 2025 14:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874196; cv=none; b=PDzEXg+NGeQltB8GOVEw6cbPMCYhc0Fk5YFqNvuoKOITlsSEPV3JA7zhwNLRu3rlzki0i+Yc0NKGRw7W51+XzvwposRKwthhQEqbMY/XoyZMZRCkjchirde2IA+fHKHll20K+CJ0nvW+mR8LSQWNz86Xu+nGEoHI0GEOOj74TiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874196; c=relaxed/simple;
	bh=6QCWUvyTMYepH4lI+/I6ynK4ceYJrbRp1xxgyiae/YE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bRfqBplJ3Elol/4axOqr7Ro5lNWShPCefBLgu/Z1MDalvuaFbBlTvpz7rTYAT/iXnvD+Gpx0mtRIhMjQC/yLXxk8tTaUN3xFced/4hBc0qvSdNm0h2OqZ5Fii6TatM+vdv1s+nEPZO2zFhuUKTU0oUFwgaf24ZZHPp7o1HuEDsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xmB4YVDu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xmB4YVDu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0C3FC4CEEB;
	Mon,  2 Jun 2025 14:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874196;
	bh=6QCWUvyTMYepH4lI+/I6ynK4ceYJrbRp1xxgyiae/YE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xmB4YVDueNx6aHdpO/u1yB+f0bBaGxThZLB99ZYyliLmP7osDP2K+iNm6btUmVUk2
	 Sgj1PIDazYL+5vzr7H55AOOAhItPMxSawvboapleI+K6kchQE4vGKMhYv9CPl6SeoU
	 hO0VKy5OZNJpMwjWHXAcypIKeHTLy/OzLZmiBdB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.6 389/444] i3c: master: svc: Fix implicit fallthrough in svc_i3c_master_ibi_work()
Date: Mon,  2 Jun 2025 15:47:33 +0200
Message-ID: <20250602134356.703707929@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Nathan Chancellor <nathan@kernel.org>

commit e8d2d287e26d9bd9114cf258a123a6b70812442e upstream.

Clang warns (or errors with CONFIG_WERROR=y):

  drivers/i3c/master/svc-i3c-master.c:596:2: error: unannotated fall-through between switch labels [-Werror,-Wimplicit-fallthrough]
    596 |         default:
        |         ^
  drivers/i3c/master/svc-i3c-master.c:596:2: note: insert 'break;' to avoid fall-through
    596 |         default:
        |         ^
        |         break;
  1 error generated.

Clang is a little more pedantic than GCC, which does not warn when
falling through to a case that is just break or return. Clang's version
is more in line with the kernel's own stance in deprecated.rst, which
states that all switch/case blocks must end in either break,
fallthrough, continue, goto, or return. Add the missing break to silence
the warning.

Fixes: 0430bf9bc1ac ("i3c: master: svc: Fix missing STOP for master request")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/r/20250319-i3c-fix-clang-fallthrough-v1-1-d8e02be1ef5c@kernel.org
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i3c/master/svc-i3c-master.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -504,6 +504,7 @@ static void svc_i3c_master_ibi_work(stru
 		break;
 	case SVC_I3C_MSTATUS_IBITYPE_MASTER_REQUEST:
 		svc_i3c_master_emit_stop(master);
+		break;
 	default:
 		break;
 	}


