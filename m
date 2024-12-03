Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB4C1F890A;
	Tue,  3 Dec 2024 15:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240889; cv=none; b=e58hakiOJNEQPumfaBIKpaUzKfuRk+5zkhtww6Io9shZV6qI1egfoQUugY+zKPSDFgwVDInGbUL3cha75kOGgsjXy7ll9WIAPn7LYis/yuUYmYadXSE/Hl2/jxKDVjQt4yH43GXd7gS0reFrCAyhvw+mXfPIjsqwWsCyOxQt4Ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240889; c=relaxed/simple;
	bh=wKhV2alU+4G5O8ifSYYhuNgJlxxOQNdTUxJUibvAVBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hRJ+ZzqaxGxJEvXTsNmEJivxqH8zYi0KRjEQ05DY0nYKrxMu6Ky1a68yPJKKdtocj/RJOGJGljXtILdxfHg0QhKm0c5Vh161TznE+zzN8xomy4JXuHWHdLYPadN6W7hjaDuKI5Poe4k+eGZpN6qnbdStLP6snH7KdezPQwhY5HM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ryRbNTXU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ryRbNTXU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BC5EC4CECF;
	Tue,  3 Dec 2024 15:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240889;
	bh=wKhV2alU+4G5O8ifSYYhuNgJlxxOQNdTUxJUibvAVBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ryRbNTXUr5sL/k9gh+nbTtyN7AwJG5kq6PIG8NAEB5MIYdCOlzAhKMwSMX+pwofSj
	 0VZ+jbRFiWpvmpZiv0Y1QnKwmgPnmc07UmU6zhMMKBBqg0N4b5zIjAgrmOvxmNw16f
	 WK48zhsvTiIMz0Ad0HNblGTwjXJ0vjBWD/T4h5hY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 265/826] selftests/bpf: fix test_spin_lock_fail.cs global vars usage
Date: Tue,  3 Dec 2024 15:39:52 +0100
Message-ID: <20241203144754.099250666@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 43f40c4fe241a..1c8b678e2e9a3 100644
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



