Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 696932C21F4;
	Thu, 15 Jan 2026 17:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498614; cv=none; b=pvr804DlWO/WpkRgafVeuvSHOiXpEEWPtu03EWPiQ3NyAQtHDpb8GxC+aS9r5yLZSyN1pSLNBsDzaDJmVyHK2N1M0yMNhgwKEK8XrKFYnE7DEFueOsdMc5EqzxKoEx+IeNgyjnnkXzhZLg+j3rew+cMNR5gGFu91JCHBY+/wHm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498614; c=relaxed/simple;
	bh=SqiFs8YR7mqMqJHqx6cUvxbkU+8o2twpqmO+aAI+7LI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QKvFs5pPk+92FQgki21vAyoL+aq+2/3ZsGA8w8UiNwDLN8MWE9P9+htHlJni1F/CYEhZvHW3OflUgZ0qm8FLqVtFpHeMurfc2ny9tKJP+xoCyJcyT7RvCpHSglonADkY4eXAVJUIwdYyrikQPQDy5ovfcARPhbwsDPwGWbpm52M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EciIZ51V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EciIZ51V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDABFC116D0;
	Thu, 15 Jan 2026 17:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498614;
	bh=SqiFs8YR7mqMqJHqx6cUvxbkU+8o2twpqmO+aAI+7LI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EciIZ51Vt1d8WkMlDsrrmRmSQHLIJiTQEP9Fn93C7TxcH2v6ABYyBMvdGH8TIVoN4
	 Cc2jtaA+oArkzh1WsR3ano2mZkvRla3d2CVT+aYT834G/O86McCoF+bC9qPjWGcu8P
	 oIt8MBiom4RbzIrEAYEPuS2XPE1t7Ipq2hmTdguY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 461/554] media: renesas: rcar_drif: fix device node reference leak in rcar_drif_bond_enabled
Date: Thu, 15 Jan 2026 17:48:47 +0100
Message-ID: <20260115164302.969084061@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 445e1658894fd74eab7e53071fa16233887574ed ]

The function calls of_parse_phandle() which returns
a device node with an incremented reference count. When the bonded device
is not available, the function
returns NULL without releasing the reference, causing a reference leak.

Add of_node_put(np) to release the device node reference.
The of_node_put function handles NULL pointers.

Found through static analysis by reviewing the doc of of_parse_phandle()
and cross-checking its usage patterns across the codebase.

Fixes: 7625ee981af1 ("[media] media: platform: rcar_drif: Add DRIF support")
Cc: stable@vger.kernel.org
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Fabrizio Castro <fabrizio.castro.jz@renesas.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/rcar_drif.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/platform/rcar_drif.c
+++ b/drivers/media/platform/rcar_drif.c
@@ -1253,6 +1253,7 @@ static struct device_node *rcar_drif_bon
 	if (np && of_device_is_available(np))
 		return np;
 
+	of_node_put(np);
 	return NULL;
 }
 


