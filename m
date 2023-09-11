Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B111170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:17:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBBBBC433C7;
	Mon, 11 Sep 2023 14:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441857;
	bh=8vONUe1tyQCdIB+KTR7VFeJqezrP1QCSG/kvTqxQ54M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wgScrEYlJBhdVbnGJ/FQC/h09ao7lCVsExX/+XQwt39D9JwTvd8O4oBE58ebwtZn+
	 Xdhb6FISmDXpP+FcPD/sGOdTROi7O3OQqRK38rKa8pUSPG8UMUZo9Df1GBKQWDyUnR
	 f1kTlToa8VTY+OZ/JMAat/7SE4sfA0askRyVUJHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junhao He <hejunhao3@huawei.com>,
	James Clark <james.clark@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 561/739] coresight: Fix memory leak in acpi_buffer->pointer
Date: Mon, 11 Sep 2023 15:46:00 +0200
Message-ID: <20230911134706.748693902@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junhao He <hejunhao3@huawei.com>

[ Upstream commit 1a9e02673e2550f5612099e64e8761f0c8fc0f50 ]

There are memory leaks reported by kmemleak:
...
unreferenced object 0xffff00213c141000 (size 1024):
  comm "systemd-udevd", pid 2123, jiffies 4294909467 (age 6062.160s)
  hex dump (first 32 bytes):
    04 00 00 00 02 00 00 00 18 10 14 3c 21 00 ff ff  ...........<!...
    00 00 00 00 00 00 00 00 03 00 00 00 10 00 00 00  ................
  backtrace:
    [<000000004b7c9001>] __kmem_cache_alloc_node+0x2f8/0x348
    [<00000000b0fc7ceb>] __kmalloc+0x58/0x108
    [<0000000064ff4695>] acpi_os_allocate+0x2c/0x68
    [<000000007d57d116>] acpi_ut_initialize_buffer+0x54/0xe0
    [<0000000024583908>] acpi_evaluate_object+0x388/0x438
    [<0000000017b2e72b>] acpi_evaluate_object_typed+0xe8/0x240
    [<000000005df0eac2>] coresight_get_platform_data+0x1b4/0x988 [coresight]
...

The ACPI buffer memory (buf.pointer) should be freed. But the buffer
is also used after returning from acpi_get_dsd_graph().
Move the temporary variables buf to acpi_coresight_parse_graph(),
and free it before the function return to prevent memory leak.

Fixes: 76ffa5ab5b79 ("coresight: Support for ACPI bindings")
Signed-off-by: Junhao He <hejunhao3@huawei.com>
Reviewed-by: James Clark <james.clark@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20230817085937.55590-2-hejunhao3@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../hwtracing/coresight/coresight-platform.c  | 40 ++++++++++++-------
 1 file changed, 26 insertions(+), 14 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-platform.c b/drivers/hwtracing/coresight/coresight-platform.c
index c8940314cceb8..dbf508fdd8d16 100644
--- a/drivers/hwtracing/coresight/coresight-platform.c
+++ b/drivers/hwtracing/coresight/coresight-platform.c
@@ -494,19 +494,18 @@ static inline bool acpi_validate_dsd_graph(const union acpi_object *graph)
 
 /* acpi_get_dsd_graph	- Find the _DSD Graph property for the given device. */
 static const union acpi_object *
-acpi_get_dsd_graph(struct acpi_device *adev)
+acpi_get_dsd_graph(struct acpi_device *adev, struct acpi_buffer *buf)
 {
 	int i;
-	struct acpi_buffer buf = { ACPI_ALLOCATE_BUFFER };
 	acpi_status status;
 	const union acpi_object *dsd;
 
 	status = acpi_evaluate_object_typed(adev->handle, "_DSD", NULL,
-					    &buf, ACPI_TYPE_PACKAGE);
+					    buf, ACPI_TYPE_PACKAGE);
 	if (ACPI_FAILURE(status))
 		return NULL;
 
-	dsd = buf.pointer;
+	dsd = buf->pointer;
 
 	/*
 	 * _DSD property consists tuples { Prop_UUID, Package() }
@@ -557,12 +556,12 @@ acpi_validate_coresight_graph(const union acpi_object *cs_graph)
  * returns NULL.
  */
 static const union acpi_object *
-acpi_get_coresight_graph(struct acpi_device *adev)
+acpi_get_coresight_graph(struct acpi_device *adev, struct acpi_buffer *buf)
 {
 	const union acpi_object *graph_list, *graph;
 	int i, nr_graphs;
 
-	graph_list = acpi_get_dsd_graph(adev);
+	graph_list = acpi_get_dsd_graph(adev, buf);
 	if (!graph_list)
 		return graph_list;
 
@@ -663,22 +662,24 @@ static int acpi_coresight_parse_graph(struct device *dev,
 				      struct acpi_device *adev,
 				      struct coresight_platform_data *pdata)
 {
+	int ret = 0;
 	int i, nlinks;
 	const union acpi_object *graph;
 	struct coresight_connection conn, zero_conn = {};
 	struct coresight_connection *new_conn;
+	struct acpi_buffer buf = { ACPI_ALLOCATE_BUFFER, NULL };
 
-	graph = acpi_get_coresight_graph(adev);
+	graph = acpi_get_coresight_graph(adev, &buf);
 	/*
 	 * There are no graph connections, which is fine for some components.
 	 * e.g., ETE
 	 */
 	if (!graph)
-		return 0;
+		goto free;
 
 	nlinks = graph->package.elements[2].integer.value;
 	if (!nlinks)
-		return 0;
+		goto free;
 
 	for (i = 0; i < nlinks; i++) {
 		const union acpi_object *link = &graph->package.elements[3 + i];
@@ -686,17 +687,28 @@ static int acpi_coresight_parse_graph(struct device *dev,
 
 		conn = zero_conn;
 		dir = acpi_coresight_parse_link(adev, link, &conn);
-		if (dir < 0)
-			return dir;
+		if (dir < 0) {
+			ret = dir;
+			goto free;
+		}
 
 		if (dir == ACPI_CORESIGHT_LINK_MASTER) {
 			new_conn = coresight_add_out_conn(dev, pdata, &conn);
-			if (IS_ERR(new_conn))
-				return PTR_ERR(new_conn);
+			if (IS_ERR(new_conn)) {
+				ret = PTR_ERR(new_conn);
+				goto free;
+			}
 		}
 	}
 
-	return 0;
+free:
+	/*
+	 * When ACPI fails to alloc a buffer, it will free the buffer
+	 * created via ACPI_ALLOCATE_BUFFER and set to NULL.
+	 * ACPI_FREE can handle NULL pointers, so free it directly.
+	 */
+	ACPI_FREE(buf.pointer);
+	return ret;
 }
 
 /*
-- 
2.40.1



