Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB281A76A4;
	Tue, 30 Jul 2024 17:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359850; cv=none; b=I/xhArRTFsRMnvDwcKgdxy+mUG0zLzFl8nas2o8LGvAJ0TvpESjy02uyTJUHpSe6kFBYbyXn9OXzXn4NwfE444/3MnpcbRLZKdmU1d6HIj77uSZpwS3mAm+arvdiZAK6xRw1S48Ret9OgH6qMKk7pwhfwue8DqgzYdOUjziuTkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359850; c=relaxed/simple;
	bh=9+/FsI9lWowplZAdZ+7C64l48zQIcq0RGFpLdk9muOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g9OxxrW8ljU/fdYrKEaaYsJZaHuwKzGZSsXnEAM29ZoJTS8ammrQ3tTs7GpQm8o0EY4AEQhnAs7iP+0p8ghdociX1QpIxbmYyAjuu3PMI9JKa6+x4VfhEysOI3CUnTba06Gx2d6waNpE5WhcEUvM7mUI0vlE5XvzY2yLJmSzYc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n/5F907k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n/5F907k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9889FC4AF0A;
	Tue, 30 Jul 2024 17:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359850;
	bh=9+/FsI9lWowplZAdZ+7C64l48zQIcq0RGFpLdk9muOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n/5F907kiMWyim3V4o7M9AOxewqf/g25lP4tkGUlxLwl2Za2nS3DO5flTqY2PO9hr
	 MwXlZMy7YlNjbgUG9uGDTEsU7cRW3kwe1XG8bOm5Vw1QDZ+BdEtLBymgdjA1y66pFJ
	 zs7fIJhXo16QMvuUQ66hI80flQ/7AbYClZqZIKNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 546/568] powerpc: fix a file leak in kvm_vcpu_ioctl_enable_cap()
Date: Tue, 30 Jul 2024 17:50:53 +0200
Message-ID: <20240730151701.502808285@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit b4cf5fc01ce83e5c0bcf3dbb9f929428646b9098 ]

missing fdput() on one of the failure exits

Fixes: eacc56bb9de3e # v5.2
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/powerpc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 7197c8256668b..6cef200c2404d 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -1990,8 +1990,10 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 			break;
 
 		r = -ENXIO;
-		if (!xive_enabled())
+		if (!xive_enabled()) {
+			fdput(f);
 			break;
+		}
 
 		r = -EPERM;
 		dev = kvm_device_from_filp(f.file);
-- 
2.43.0



