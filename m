Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30D782512DD;
	Mon, 23 Jun 2025 13:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684174; cv=none; b=pp3a0gK4XRBi5WEl7LwPXzqfHPJTnSeKXxKm2u0iv/lUl2yO3NZnc7LdbLl1MF7C51zXvtgZj0c8ySKnKPyGecKl5LYlB7IVNSpKMB3OTCWUmt8+UEsiLOopSshwgl3m/mHi+tr7Wli51XKKA9dW+2HZQ83vrsRgTbfnfgfGt2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684174; c=relaxed/simple;
	bh=uHKSqC4o+FVgpVkqX3ruBFd1vaffxZZDXZAxHNMxo2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C8HRR8Igrm/1AMOlEwV1Cad++rF7ZyFxSEZx+X0SDjjHjPcTUSxHv6nkvB1n8OPtWI/3us7hbtS6KPUKXIFmQ2KmelvalVsd79DI8KtaNjLXqkysFnkIJAR6/LtUpEJ9euYKpB1JMvVapZLoI7sUYe6LmlMOwMoEMLYDo36qYGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1u35IpA8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1u35IpA8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F586C4CEEA;
	Mon, 23 Jun 2025 13:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684173;
	bh=uHKSqC4o+FVgpVkqX3ruBFd1vaffxZZDXZAxHNMxo2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1u35IpA8evvgCqU2w3MAz+P3ElPX8S+RygZ3X80sjAy/vaiIkEakjPba4mX1ggDyT
	 c9NTwFJUG6W4lwSWkUFAzRZp3vDshOjAQ+iOyOaohNN2CiJpz7izO0eqM1imrr3fgN
	 +/xtOMqqyfoeRcwQ0hR9XObfa40kiHLVClWIMv4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joel Becker <jlbec@evilplan.org>,
	Breno Leitao <leitao@debian.org>,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Andreas Hindborg <a.hindborg@kernel.org>
Subject: [PATCH 6.12 001/414] configfs: Do not override creating attribute file failure in populate_attrs()
Date: Mon, 23 Jun 2025 15:02:18 +0200
Message-ID: <20250623130642.057039674@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

commit f830edbae247b89228c3e09294151b21e0dc849c upstream.

populate_attrs() may override failure for creating attribute files
by success for creating subsequent bin attribute files, and have
wrong return value.

Fix by creating bin attribute files under successfully creating
attribute files.

Fixes: 03607ace807b ("configfs: implement binary attributes")
Cc: stable@vger.kernel.org
Reviewed-by: Joel Becker <jlbec@evilplan.org>
Reviewed-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20250507-fix_configfs-v3-2-fe2d96de8dc4@quicinc.com
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/configfs/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -600,7 +600,7 @@ static int populate_attrs(struct config_
 				break;
 		}
 	}
-	if (t->ct_bin_attrs) {
+	if (!error && t->ct_bin_attrs) {
 		for (i = 0; (bin_attr = t->ct_bin_attrs[i]) != NULL; i++) {
 			if (ops && ops->is_bin_visible && !ops->is_bin_visible(item, bin_attr, i))
 				continue;


