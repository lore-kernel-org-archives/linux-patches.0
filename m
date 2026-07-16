Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F2B3F482E;
	Thu, 16 Jul 2026 14:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210990; cv=none; b=GG181n3ZXHXqy9QAnuh+9gj9/bSBQ6QZ1MO7VftRROq8nDlKOwqxS632AJikbhNmTrjAwp1PH+5dh8cLfZYcZVB0zW0HgZmn4earxCZQjWJOOJloUVRfhXcs0pDr/whHqo+70k7ytEUgiVMneqJLU+Ip91QgOnf+9KLLUyIR1Iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210990; c=relaxed/simple;
	bh=cJ5WfhJq710Sqoc4jTQJ52iPCok7iTkqUEHd/XLSWcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RklFzq5MWcyGdoZQ989HtDHwcKGVdNaIe7cp+zeUqU+i4bEh2hPlzPoJWO92eeEWEKB2MTE2Ld1tNb97+cz5PzdR4DaC68+A6iQx9efhGTO9heOIBGEtudJ6ocChNlBQbemVLfyp0y74ZZYgii3hTS/y6vbLXdxnk7kV5PwnIxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CX0VEmT0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CX0VEmT0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37A911F00A3D;
	Thu, 16 Jul 2026 14:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210988;
	bh=N53uhlRSrnGT5bZ4Bq2hPrFnB9qCSCR6GclZxtOMAcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CX0VEmT0XnpY9sI9Qd9zgHhDvwcpI2xX8djS3mV1vPboHwq1e60Z2Io/KPrNf5ARA
	 D6j7vfmAm1PW3HXjrQvYu+G4Kl9MQ4EvDdole4KElWf/XsiCkrcirAZchqO2A8vY4E
	 8ArpAiswWpMmMOdfPzTp8OcMPfBbYjvHRvU0u7uQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Xuewen Wang <wangxuewen@kylinos.cn>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [PATCH 6.18 257/480] tools/mm/slabinfo: Fix trace disable logic inversion
Date: Thu, 16 Jul 2026 15:30:04 +0200
Message-ID: <20260716133050.375689555@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Xuewen Wang <wangxuewen@kylinos.cn>

commit 235ab68d67eadbef1fdbfb771f21f5bacc77a2ae upstream.

The disable trace path in slab_debug() had a logic error where it would
set trace=1 instead of trace=0. This made trace functionality permanently
enabled once turned on for any slab cache.

Fixes: a87615b8f9e2 ("SLUB: slabinfo upgrade")
Cc: stable@vger.kernel.org
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Xuewen Wang <wangxuewen@kylinos.cn>
WARNING: From:/Signed-off-by: email address mismatch: 'From: wangxuewen <18810879172@163.com>' != 'Signed-off-by: wangxuewen <wangxuewen@kylinos.cn>'
Link: https://patch.msgid.link/20260518062159.80664-2-wangxuewen@kylinos.cn
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/mm/slabinfo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/mm/slabinfo.c
+++ b/tools/mm/slabinfo.c
@@ -798,7 +798,7 @@ static void slab_debug(struct slabinfo *
 			fprintf(stderr, "%s can only enable trace for one slab at a time\n", s->name);
 	}
 	if (!tracing && s->trace)
-		set_obj(s, "trace", 1);
+		set_obj(s, "trace", 0);
 }
 
 static void totals(void)


