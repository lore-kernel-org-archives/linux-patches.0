Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD75D3FFAD1;
	Tue, 21 Jul 2026 17:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653693; cv=none; b=EzqTYgDqi1HWI1H85soy0MJAJ60Ij5Emtxr0Xam1KGL6cvH19QPWPU7YbcmTVy6uFkPVM+MtU6LuoueVYCkAixf46Bs5cKlbkxtVfCtkQ2L7w5+EDh36WIUmoj71RXvDvvEI+53Nnbeb6V+TZF2Gt5B0ikTxOk9h57dXcTi+Sqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653693; c=relaxed/simple;
	bh=F2Ieaak7wF6V16j0CFJgnG9jHQ7W+rLceUK+ujR7h74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=knEbIYJ/MRVDqVEz/faOHrvGw9mjAKrg4L8Qt/goHy/y8h3F4+MsvkQ3Fi1IOWR7l7iLsGWT0xKo3vWsca+a0cNGOCuCsbo3OY9cPrpdJPMxOWkFHgJmH52By2VxJWANDfzxQZPed0znKP7DYtuDdOH3SSA1drDbvBD6wj5MbCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x1XyMpvd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x1XyMpvd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84A3D1F00A3E;
	Tue, 21 Jul 2026 17:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653687;
	bh=gg4tRQqxGD4+d9Cm0KQjqEAtuvexpXUv0iK3osXrmQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x1XyMpvdRGfAmMQpmbn8auZyhNSi1SVvOTl8/hTC+M2RfbN5LIrFsLvCJsv3Vm1BX
	 oOWT33dCitIaHI08DzRW8AEejbzE5q0LK8l38Wx3i9Ib5xBbNE4nUsNZae8u+FGFuB
	 PdwGldjzwn8Z11GW55M0vX1TRjVyCv/mplKkismk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1420/2077] selftests/hid: Load only requested struct_ops maps
Date: Tue, 21 Jul 2026 17:18:13 +0200
Message-ID: <20260721152626.294651875@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>

[ Upstream commit 5aad55011a37d999cf99d14bafb6a093a1a70466 ]

The HID selftest skeleton contains several struct_ops maps, but each test
usually wants to load only the programs named by that test.

load_programs() disabled auto-attach for all maps, but left struct_ops
autocreate enabled. libbpf can enable autoload for programs referenced by
autocreated struct_ops maps, so an unrelated program can be loaded and fail
even when the current test does not use it.

Disable autocreate for all struct_ops maps by default, then re-enable it
only for the maps selected by the test before loading the skeleton.

Signed-off-by: Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>
Fixes: f64c1a459339 ("selftests/hid: disable struct_ops auto-attach")
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/hid/hid_bpf.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/hid/hid_bpf.c b/tools/testing/selftests/hid/hid_bpf.c
index 1e979fb3542bab..269256e1decd84 100644
--- a/tools/testing/selftests/hid/hid_bpf.c
+++ b/tools/testing/selftests/hid/hid_bpf.c
@@ -86,6 +86,20 @@ static void load_programs(const struct test_program programs[],
 	self->skel = hid__open();
 	ASSERT_OK_PTR(self->skel) TEARDOWN_LOG("Error while calling hid__open");
 
+	/*
+	 * Disable all struct_ops maps by default so libbpf does not autoload
+	 * programs referenced by maps that are unrelated to the current test.
+	 */
+	bpf_object__for_each_map(iter_map, *self->skel->skeleton->obj) {
+		if (bpf_map__type(iter_map) == BPF_MAP_TYPE_STRUCT_OPS) {
+			err = bpf_map__set_autocreate(iter_map, false);
+			ASSERT_OK(err) TH_LOG("can not disable struct_ops map '%s'",
+					      bpf_map__name(iter_map));
+		}
+
+		bpf_map__set_autoattach(iter_map, false);
+	}
+
 	for (int i = 0; i < progs_count; i++) {
 		struct bpf_program *prog;
 		struct bpf_map *map;
@@ -102,6 +116,10 @@ static void load_programs(const struct test_program programs[],
 		ASSERT_OK_PTR(map) TH_LOG("can not find struct_ops by name '%s'",
 					  programs[i].name + 4);
 
+		err = bpf_map__set_autocreate(map, true);
+		ASSERT_OK(err) TH_LOG("can not enable struct_ops map '%s'",
+				      programs[i].name + 4);
+
 		/* hid_id is the first field of struct hid_bpf_ops */
 		ops_hid_id = bpf_map__initial_value(map, NULL);
 		ASSERT_OK_PTR(ops_hid_id) TH_LOG("unable to retrieve struct_ops data");
@@ -109,13 +127,6 @@ static void load_programs(const struct test_program programs[],
 		*ops_hid_id = self->hid.hid_id;
 	}
 
-	/* we disable the auto-attach feature of all maps because we
-	 * only want the tested one to be manually attached in the next
-	 * call to bpf_map__attach_struct_ops()
-	 */
-	bpf_object__for_each_map(iter_map, *self->skel->skeleton->obj)
-		bpf_map__set_autoattach(iter_map, false);
-
 	err = hid__load(self->skel);
 	ASSERT_OK(err) TH_LOG("hid_skel_load failed: %d", err);
 
-- 
2.53.0



