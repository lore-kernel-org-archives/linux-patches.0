Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A471F4709;
	Tue,  3 Dec 2024 15:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238482; cv=none; b=Os7y2swyeeAhjK1JLoLvl29QbG3wmOpKZwfVEni2a23qsKoNnD5ZHHBQm8vGAWwcCFkbxVuGZg/KJueDILcsDwlqcoo90mFrGbnLw+KvxAFKgkpBNkOtNUZFMjEoqZCiYPAKb3XgYeHLW9YszEAE/TxcnMpkYFssnS6vuXD550M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238482; c=relaxed/simple;
	bh=u0GrJHKpZqckOYvKxfQzGldbDiFfcrjLfqdrS8+os0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mKDCC64R5KBSr3oiXutT9cZqUV4KoiFUQumPG4WRyOWy56u33zTnP5fS30sojhnHj3C7UwJUYSolfIoxwB1EhfVlKi9eHV7JHsjOjt4F5o2+3768Z6CglS69twaqax7IYHoDuV2XBy5+XNr1WBpSYOZXY8r4Z+WpLnR+0igJEnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NRPbwV3G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NRPbwV3G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B3C3C4CECF;
	Tue,  3 Dec 2024 15:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238482;
	bh=u0GrJHKpZqckOYvKxfQzGldbDiFfcrjLfqdrS8+os0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NRPbwV3GroelHSlkVezKedi/nxXMDm0tlKIRnLEEysNJPD4SJgUI46ud/atzlh5bL
	 OzKD+JPXYQUbobBvH6a+VIu6kmHzt5CIvzC+s/Wmy2EbSzz98x9LPEZpwoPyCnaIdV
	 MMMwvGwVt0lJ2Ta7uijST2p5GDO3sAGeWdwxMoX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 292/817] selftests/bpf: fix test_spin_lock_fail.cs global vars usage
Date: Tue,  3 Dec 2024 15:37:44 +0100
Message-ID: <20241203144007.208539286@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



