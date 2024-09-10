Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D365319923A;
	Tue, 10 Sep 2024 10:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962964; cv=none; b=P6+9ocnnhJmGIdvSSbMCUk99J1XKDBDtv3xZwkPCYX0jmDkEtNLzG9N7AV5AOOn3ImdXvt7gG/VywX0/Y8y7OBmOvZlpWDzefCzYEgC96dyO3MQVeLOjm7p42DYL2XjQohN+Puq6j1k+f2xoGvA6jjO4Q8kJAPzaApksBQFlJzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962964; c=relaxed/simple;
	bh=Mhxb1zureV9fOYdsWRu37I78GKSVjt6gXOlNuUAHvHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sBTRQR2dRisYx4bA1JWwjKZDqUbfKEdRk0IAe9XK4n+N1P9cTkdZwJj9eG8iN6R5EemAU8KGh3NurRt6HSjBf1wegy/U1ur4zUeaInfqrp3ZFItVjw+tzsJ03MC/7yXGLboCR69T+xutgpA/9SIdlE1YyQ/XWuvQqJcWqQ+iaVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fVooKnFg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fVooKnFg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A402C4CEC3;
	Tue, 10 Sep 2024 10:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962964;
	bh=Mhxb1zureV9fOYdsWRu37I78GKSVjt6gXOlNuUAHvHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fVooKnFgaqCdjniQJs46omwr8oP/Wm4T/qgFHNLZycgAdynIsFQjz4iRHBGs8jcrg
	 GF/YZgzosYAuj9WXZjSw4pNKviiRrxXLJ+oi6LmHwGVwuz2kT+Fdmqp2a6Y9JWt3MR
	 4XfQztFavpOP1ll0Mf+QQD7SDgHO56SVb/8S/KmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 090/192] ASoC: topology: Properly initialize soc_enum values
Date: Tue, 10 Sep 2024 11:31:54 +0200
Message-ID: <20240910092601.703188692@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>

[ Upstream commit 8ec2a2643544ce352f012ad3d248163199d05dfc ]

soc_tplg_denum_create_values() should properly set its values field.

Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Link: https://patch.msgid.link/20240627101850.2191513-4-amadeuszx.slawinski@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-topology.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/soc-topology.c b/sound/soc/soc-topology.c
index fcb8a36d4a06..77296c950376 100644
--- a/sound/soc/soc-topology.c
+++ b/sound/soc/soc-topology.c
@@ -889,6 +889,8 @@ static int soc_tplg_denum_create_values(struct soc_tplg *tplg, struct soc_enum *
 		se->dobj.control.dvalues[i] = le32_to_cpu(ec->values[i]);
 	}
 
+	se->items = le32_to_cpu(ec->items);
+	se->values = (const unsigned int *)se->dobj.control.dvalues;
 	return 0;
 }
 
-- 
2.43.0



