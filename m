Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EFA0158A03;
	Tue,  9 Jul 2024 11:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523840; cv=none; b=kM7kHbjBE9D/mKiQnNwyOUb3Q8g7gEvyiBp1bhEVwZSk6Gz0WlaGmLCKIVgIi72abj7uAh1muWFxXYC+3Pvw0QFziDCqkj8nuiLg30KDT6NK6wT6YSYTXnK8BTnUFwJCJHMj024s21vn+XRY/Ejn7VnhxmQJtLGZO71TUqDNfRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523840; c=relaxed/simple;
	bh=cHc38JZKt87Zb1CdI5+A2nBV7Fucrv9ksFHAfPNqGkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LMLIYbIY6iSc1EDz7WXCvxcKZRsZSUIeZlmwi13u7ItWef1M0Bek0p32myx6l5hrRNOhfjmj+VSTSttXWYWLAQr/fowzF5tKnrscAt7xxwF3Pk+moMgXBGsK+bp8g5/m4wPCRV/B0aHnLaETLKkX5/L6Ty2g8hhT1NUwhgim33Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HpQdO6sa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HpQdO6sa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B0F0C3277B;
	Tue,  9 Jul 2024 11:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523839;
	bh=cHc38JZKt87Zb1CdI5+A2nBV7Fucrv9ksFHAfPNqGkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HpQdO6saZstSeBfvhWpZnWEr/jccd3yQB64gXGxpvAkfsfcGHflRblhK97OL6JZCd
	 yEjH41tD28QQ7Xq87Td/gdombzpcBztgBSaROoPFEsJNMlxLniCzEAvyFFGz1xCOuu
	 ilq4ea5aGhroGH/3hA21s/CEnwWyWzKUVPqHKLs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Jan <zoo868e@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 127/139] connector: Fix invalid conversion in cn_proc.h
Date: Tue,  9 Jul 2024 13:10:27 +0200
Message-ID: <20240709110703.077276187@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Jan <zoo868e@gmail.com>

[ Upstream commit 06e785aeb9ea8a43d0a3967c1ba6e69d758e82d4 ]

The implicit conversion from unsigned int to enum
proc_cn_event is invalid, so explicitly cast it
for compilation in a C++ compiler.
/usr/include/linux/cn_proc.h: In function 'proc_cn_event valid_event(proc_cn_event)':
/usr/include/linux/cn_proc.h:72:17: error: invalid conversion from 'unsigned int' to 'proc_cn_event' [-fpermissive]
   72 |         ev_type &= PROC_EVENT_ALL;
      |                 ^
      |                 |
      |                 unsigned int

Signed-off-by: Matt Jan <zoo868e@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/cn_proc.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/uapi/linux/cn_proc.h b/include/uapi/linux/cn_proc.h
index f2afb7cc4926c..18e3745b86cd4 100644
--- a/include/uapi/linux/cn_proc.h
+++ b/include/uapi/linux/cn_proc.h
@@ -69,8 +69,7 @@ struct proc_input {
 
 static inline enum proc_cn_event valid_event(enum proc_cn_event ev_type)
 {
-	ev_type &= PROC_EVENT_ALL;
-	return ev_type;
+	return (enum proc_cn_event)(ev_type & PROC_EVENT_ALL);
 }
 
 /*
-- 
2.43.0



