Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9210A13AA5F;
	Fri,  6 Dec 2024 15:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497222; cv=none; b=RvJ3dekThznzUujiaoA1c5FS5iDuI8YdiwbRkpG/k5KD4UG5CEgw5XwkQcnIkWTGh3drn6W1jPGWvPyPmlDQtvJZv+wIo5cc/xD+sPhmxSjkEIK+d6cffwoqgXimTkP+eqgfQmgUeA5QG/kktRXx07NwHe7VXiU/QC6Vlan5hHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497222; c=relaxed/simple;
	bh=xwKc2UONLDEE2gumSuKGcDYSV+hUXPRMUHKrW1A3uOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hRfDEKtaPS+nzi9QPl7cPyl8kcy2XO/qN9fBne/kqNQoodp9e44yFjB33nPOV3YDGixnIiTjmgUPLVtC+l8Pmca09AcsnCQWGrq9B6DAfFL9VUvsN1Mu1CMUTtw/tz2F0cMS33oWBaap8G4YbQHOguvt4p3Eg3RbuAN8iam4u88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nee1NuUa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nee1NuUa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 017DCC4CED1;
	Fri,  6 Dec 2024 15:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497222;
	bh=xwKc2UONLDEE2gumSuKGcDYSV+hUXPRMUHKrW1A3uOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nee1NuUaU6TqPeI9YH7uHfg9e4HModNYUjI8OmNsb6QVn9Ltos8MIJVJ9xsIHQOfk
	 cGAU13j/vpbLU3EOJcWAMGN8J/XQAriQ/GJWGA5wYyStu9Hv43QN/kdHWNwhq5cOZd
	 iw5nD3IUs8U/KLpjPQoTEsuKU3MX2WZko+S75PxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 212/676] selftests/bpf: fix test_spin_lock_fail.cs global vars usage
Date: Fri,  6 Dec 2024 15:30:31 +0100
Message-ID: <20241206143701.623121452@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 1b2bfc29695d273492c3dd8512775261f3272686 ]

Global variables of special types (like `struct bpf_spin_lock`) make
underlying ARRAY maps non-mmapable. To make this work with libbpf's
mmaping logic, application is expected to declare such special variables
as static, so libbpf doesn't even attempt to mmap() such ARRAYs.

test_spin_lock_fail.c didn't follow this rule, but given it relied on
this test to trigger failures, this went unnoticed, as we never got to
the step of mmap()'ing these ARRAY maps.

It is fragile and relies on specific sequence of libbpf steps, which are
an internal implementation details.

Fix the test by marking lockA and lockB as static.

Fixes: c48748aea4f8 ("selftests/bpf: Add failure test cases for spin lock pairing")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/r/20241023043908.3834423-2-andrii@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/progs/test_spin_lock_fail.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/test_spin_lock_fail.c b/tools/testing/selftests/bpf/progs/test_spin_lock_fail.c
index 86cd183ef6dc8..293ac1049d388 100644
--- a/tools/testing/selftests/bpf/progs/test_spin_lock_fail.c
+++ b/tools/testing/selftests/bpf/progs/test_spin_lock_fail.c
@@ -28,8 +28,8 @@ struct {
 	},
 };
 
-SEC(".data.A") struct bpf_spin_lock lockA;
-SEC(".data.B") struct bpf_spin_lock lockB;
+static struct bpf_spin_lock lockA SEC(".data.A");
+static struct bpf_spin_lock lockB SEC(".data.B");
 
 SEC("?tc")
 int lock_id_kptr_preserve(void *ctx)
-- 
2.43.0



